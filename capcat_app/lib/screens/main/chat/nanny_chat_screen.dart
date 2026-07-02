import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/models/message.dart';
import 'package:capcat_doca/models/nanny_welcome.dart';
import 'package:capcat_doca/models/product.dart';
import 'package:capcat_doca/providers/nanny_chat_provider.dart';
import 'package:capcat_doca/services/chat_attachment_service.dart';
import 'package:capcat_doca/services/image_picker_service.dart';
import 'package:capcat_doca/services/nanny_welcome_remote_service.dart';
import 'package:capcat_doca/screens/main/chat/shared/chat_screen_contract.dart';
import 'package:capcat_doca/screens/main/chat/shared/controller/chat_presentation_controller.dart';
import 'package:capcat_doca/screens/main/chat/shared/message_actions/chat_message_actions_resolver.dart';
import 'package:capcat_doca/screens/main/chat/shared/message_actions/chat_message_actions_sheet.dart';
import 'package:capcat_doca/screens/main/chat/shared/sections/chat_message_states_section.dart';
import 'package:capcat_doca/screens/main/chat/shared/sections/chat_screen_shell.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/assistant_chat_input_group.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_attachment_preview.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_rich_bubbles.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_text_bubble.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/fade_in_wrapper.dart';
import 'package:capcat_doca/widgets/viewer/full_screen_gallery_viewer.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NannyChatScreen extends ConsumerStatefulWidget {
  const NannyChatScreen({super.key});

  @override
  ConsumerState<NannyChatScreen> createState() => _NannyChatScreenState();
}

class _NannyChatScreenState extends ConsumerState<NannyChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DateFormat _timeFormatter = DateFormat('HH:mm');
  final GlobalKey _inputGroupKey = GlobalKey();

  late final ChatPresentationController _presentationController;
  late final AnimationController _highlightPulseController;
  late final StreamSubscription<bool> _keyboardSubscription;
  ProviderSubscription<AsyncValue<List<Message>>>? _messagesSubscription;
  ProviderSubscription<bool>? _typingSubscription;
  ProviderSubscription<String?>? _focusMessageSubscription;
  final Map<String, GlobalKey> _messageItemKeys = <String, GlobalKey>{};
  String? _highlightedMessageId;

  bool _isSending = false;
  bool _isUploadingImage = false;
  bool _isKeyboardVisible = false;
  bool _isLoadingWelcome = false;
  NannyWelcomeContent? _welcomeContent;
  String? _welcomeError;
  final List<String> _pendingAttachmentUrls = [];

  ChatScreenContract get _contract => ChatScreenContracts.nanny;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _presentationController = ChatPresentationController(vsync: this);
    _highlightPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _highlightPulseController.addStatusListener((status) {
      if (status != AnimationStatus.completed) return;
      if (!mounted || _highlightedMessageId == null) return;
      setState(() => _highlightedMessageId = null);
    });

    _keyboardSubscription = KeyboardVisibilityController().onChange.listen((
      bool visible,
    ) {
      _isKeyboardVisible = visible;
      if (visible) {
        _ensureLatestMessagesVisible(300);
      }
    });

    _scrollController.addListener(_clampScrollBounds);
    _messagesSubscription = ref.listenManual<AsyncValue<List<Message>>>(
      nannyMessagesProvider,
      (prev, next) {
        final prevCount = prev?.valueOrNull?.length ?? 0;
        final nextCount = next.valueOrNull?.length ?? 0;
        if (nextCount > prevCount) {
          _scrollToBottom(500);
        }
      },
    );
    _typingSubscription = ref.listenManual<bool>(nannyTypingProvider, (
      prev,
      next,
    ) {
      if (next == true && prev != true) {
        _scrollToBottom(300);
      }
    });
    _focusMessageSubscription = ref.listenManual<String?>(
      nannyFocusMessageRequestProvider,
      (_, next) {
        if (next == null || next.trim().isEmpty) return;
        unawaited(_handleFocusMessageRequest(next));
      },
    );
    unawaited(ref.read(nannyProfileProvider.notifier).refreshSilently());
    unawaited(_fetchNannyWelcomeContent());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_clampScrollBounds);
    _controller.dispose();
    _scrollController.dispose();
    _presentationController.dispose();
    _highlightPulseController.dispose();
    _messagesSubscription?.close();
    _typingSubscription?.close();
    _focusMessageSubscription?.close();
    _keyboardSubscription.cancel();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  Future<void> _onRefresh() {
    return ref.read(nannyMessagesProvider.notifier).refresh();
  }

  void _handleSendText(String rawText) {
    unawaited(_sendMessage(rawText));
  }

  void _onTapCamera() => unawaited(_pickAndSendFromCamera());

  void _onTapImage() => unawaited(_pickAndSendFromGallery());

  Future<void> _fetchNannyWelcomeContent({bool forceRefresh = false}) async {
    if (_isLoadingWelcome && !forceRefresh) return;

    if (mounted) {
      setState(() {
        _isLoadingWelcome = true;
        _welcomeError = null;
      });
    }

    final response = await NannyWelcomeRemoteService.getWelcomeContent();
    if (!mounted) return;

    setState(() {
      if (response.isSuccess && response.data != null) {
        _welcomeContent = response.data;
        _welcomeError = null;
      } else {
        _welcomeContent = null;
        _welcomeError = response.message ?? 'Không tải được nội dung gợi ý';
      }
      _isLoadingWelcome = false;
    });
  }

  Future<void> _sendMessage(String rawText) async {
    if (_isSending || _isUploadingImage) return;
    final text = rawText.trim();
    final hasAttachments = _pendingAttachmentUrls.isNotEmpty;
    if (text.isEmpty && !hasAttachments) return;

    setState(() => _isSending = true);
    final attachmentCopy = hasAttachments
        ? List<String>.from(_pendingAttachmentUrls)
        : null;
    final sent = await ref
        .read(nannyMessagesProvider.notifier)
        .sendMessage(content: text, imageUrls: attachmentCopy);

    if (!mounted) return;
    if (sent) {
      _controller.clear();
      if (hasAttachments) {
        setState(() => _pendingAttachmentUrls.clear());
      }
      _scrollToBottom(600);
    } else {
      ToastOverlay.show(context, 'Không gửi được tin nhắn, vui lòng thử lại.');
    }

    setState(() => _isSending = false);
  }

  Future<String?> _resolveNannyConversationId() async {
    final cached = ref.read(nannyProfileProvider).valueOrNull?.conversationId;
    if (cached != null && cached.isNotEmpty) return cached;

    try {
      await ref.read(nannyProfileProvider.notifier).refreshSilently();
    } catch (_) {
      // Ignore and fallback to current provider snapshot.
    }
    final refreshed = ref
        .read(nannyProfileProvider)
        .valueOrNull
        ?.conversationId;
    if (refreshed != null && refreshed.isNotEmpty) return refreshed;
    return null;
  }

  Future<void> _pickAndSendFromCamera() async {
    if (_isUploadingImage || _isSending) return;
    final picked = await ImagePickerService.pickFromCamera(context);
    if (!mounted) return;
    final paths = picked?.paths ?? const <String>[];
    if (paths.isEmpty) return;
    _handleImageSelection(paths);
  }

  Future<void> _pickAndSendFromGallery() async {
    if (_isUploadingImage || _isSending) return;
    final picked = await ImagePickerService.pickFromGallery(
      context,
      allowMultiple: true,
    );
    if (!mounted) return;
    final paths = picked?.paths ?? const <String>[];
    if (paths.isEmpty) return;
    _handleImageSelection(paths);
  }

  void _handleImageSelection(List<String> paths) {
    unawaited(_uploadAndAttachImages(paths));
  }

  Future<void> _uploadAndAttachImages(List<String> paths) async {
    if (paths.isEmpty) return;

    if (_isUploadingImage) return;
    setState(() => _isUploadingImage = true);

    try {
      final conversationId = await _resolveNannyConversationId();
      if (!mounted) return;
      if (conversationId == null || conversationId.isEmpty) {
        ToastOverlay.show(context, 'Không lấy được cuộc trò chuyện của Nanny.');
        return;
      }

      final uploadResult = await ChatAttachmentService.uploadMultipleImages(
        conversationId: conversationId,
        imagePaths: paths,
      );
      if (!mounted) return;

      if (!uploadResult.isSuccess ||
          uploadResult.data == null ||
          uploadResult.data!.isEmpty) {
        ToastOverlay.show(
          context,
          uploadResult.message ?? 'Gửi ảnh thất bại, vui lòng thử lại.',
        );
        return;
      }

      _addPendingAttachments(uploadResult.data!);
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  void _addPendingAttachments(List<String> urls) {
    if (urls.isEmpty) return;
    setState(() => _pendingAttachmentUrls.addAll(urls));
  }

  void _removePendingAttachmentAt(int index) {
    if (index < 0 || index >= _pendingAttachmentUrls.length) return;
    setState(() => _pendingAttachmentUrls.removeAt(index));
  }

  void _onSuggestionTap(String text) {
    unawaited(_sendMessage(text));
  }

  void _showToast(String message) {
    if (!mounted) return;
    ToastOverlay.show(context, message);
  }

  Future<void> _toggleMessagePinned(Message message) async {
    final messageId = message.id;
    if (messageId == null || messageId.trim().isEmpty) return;
    final nextPinned = !message.isPinned;
    final ok = await ref
        .read(nannyMessagesProvider.notifier)
        .setMessagePinned(messageId: messageId, isPinned: nextPinned);
    if (!mounted || ok) return;
    _showToast('Không cập nhật được trạng thái lưu tin.');
  }

  Future<void> _handleFocusMessageRequest(String messageId) async {
    final trimmed = messageId.trim();
    if (trimmed.isEmpty) return;
    await _jumpToMessageById(trimmed);
    if (!mounted) return;
    ref.read(nannyFocusMessageRequestProvider.notifier).state = null;
  }

  Future<void> _jumpToMessageById(String messageId) async {
    final index = await _ensureMessageLoaded(messageId);
    if (!mounted) return;
    if (index < 0) {
      _showToast('Không tìm thấy tin nhắn đã chọn.');
      return;
    }
    await _scrollToMessageById(messageId, index);
    _highlightMessage(messageId);
  }

  Future<int> _ensureMessageLoaded(String messageId) async {
    final controller = ref.read(nannyMessagesProvider.notifier);
    while (mounted) {
      final messages =
          ref.read(nannyMessagesProvider).valueOrNull ?? <Message>[];
      final index = messages.indexWhere((message) => message.id == messageId);
      if (index >= 0) return index;
      if (!controller.hasMore) return -1;
      await controller.loadMore();
      await Future<void>.delayed(const Duration(milliseconds: 80));
    }
    return -1;
  }

  Future<void> _scrollToMessageById(String messageId, int index) async {
    for (var attempt = 0; attempt < 8 && mounted; attempt++) {
      final targetContext = _messageItemKeys[messageId]?.currentContext;
      if (targetContext != null) {
        if (!targetContext.mounted) continue;
        await Scrollable.ensureVisible(
          targetContext,
          alignment: 0.2,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
        return;
      }

      if (_scrollController.hasClients) {
        final messagesCount =
            (ref.read(nannyMessagesProvider).valueOrNull ?? const <Message>[])
                .length;
        final denominator = messagesCount > 1 ? messagesCount - 1 : 1;
        final ratio = (index / denominator).clamp(0.0, 1.0);
        final max = _scrollController.position.maxScrollExtent;
        final target = (max * ratio).clamp(0.0, max);
        await _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 90));
    }
  }

  void _highlightMessage(String messageId) {
    _highlightPulseController
      ..stop()
      ..reset();
    setState(() => _highlightedMessageId = messageId);
    unawaited(_highlightPulseController.forward());
  }

  GlobalKey? _messageKeyFor(String? messageId) {
    if (messageId == null || messageId.isEmpty) return null;
    return _messageItemKeys.putIfAbsent(
      messageId,
      () => GlobalKey(debugLabel: 'nanny_message_$messageId'),
    );
  }

  void _scheduleInitialScrollAndReveal() {
    _presentationController.scheduleInitialScrollAndReveal(
      scrollController: _scrollController,
      isMounted: () => mounted,
      requestRebuild: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  void _scrollToBottom(int milliseconds) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final target = _scrollController.position.maxScrollExtent;
      if (milliseconds <= 0) {
        _scrollController.jumpTo(target);
      } else {
        _scrollController.animateTo(
          target,
          duration: Duration(milliseconds: milliseconds),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _ensureLatestMessagesVisible(int durationMs) {
    Future.delayed(Duration(milliseconds: durationMs), () {
      if (!mounted) return;
      _scrollToBottom(300);
    });
  }

  void _clampScrollBounds() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final max = position.maxScrollExtent;
    if (position.pixels > max) {
      _scrollController.jumpTo(max);
    }
  }

  bool _isPointInside(GlobalKey key, Offset globalPoint) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return false;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    return rect.contains(globalPoint);
  }

  void _handleGlobalPointerDown(PointerDownEvent event) {
    if (_isPointInside(_inputGroupKey, event.position)) return;
    if (_isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }
  }

  void _showImageFullscreen(String imageUrl, List<String> allImages) {
    final urls = allImages.isNotEmpty ? allImages : [imageUrl];
    final initialIndex = urls.indexOf(imageUrl);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenGalleryViewer(
          imageUrls: urls,
          initialIndex: initialIndex >= 0 ? initialIndex : 0,
        ),
      ),
    );
  }

  Widget _buildPinnedBubbleBadge(Widget bubbleBody) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        bubbleBody,
        Positioned(
          top: -SC.sh(4),
          right: -SC.sw(4),
          child: Container(
            width: SC.sw(24),
            height: SC.sh(24),
            decoration: BoxDecoration(
              color: AC.white.withValues(alpha: 0.92),
              shape: BoxShape.circle,
              border: Border.all(color: AC.greyLine2),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/pin.svg',
                width: SC.sw(15),
                height: SC.sh(15),
                colorFilter: const ColorFilter.mode(
                  AC.greenText1,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    List<Message> messages,
    int index,
  ) {
    final msg = messages[index];
    final isMe = msg.isSentByUser;
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.7;
    final actions = resolveChatMessageActions(
      kind: _contract.kind,
      message: msg,
      onTogglePin: () => _toggleMessagePinned(msg),
    );
    final rawBubbleBody = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxBubbleWidth),
      child: _buildBubbleBody(msg, maxBubbleWidth),
    );
    final bubbleBody = msg.isPinned
        ? _buildPinnedBubbleBadge(rawBubbleBody)
        : rawBubbleBody;
    final bubbleBodyWithLongPress = actions.isEmpty
        ? bubbleBody
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPressStart: (details) async {
              await showChatMessageActionsSheet(
                context,
                actions: actions,
                anchor: details.globalPosition,
              );
            },
            child: bubbleBody,
          );

    final bool isHighlighted =
        _highlightedMessageId != null && _highlightedMessageId == msg.id;
    final Widget bubbleBodyWithHighlight = Stack(
      clipBehavior: Clip.none,
      children: [
        bubbleBodyWithLongPress,
        if (isHighlighted)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _highlightPulseController,
                builder: (context, _) {
                  final timeline = _highlightPulseController.value;
                  final intensity = timeline < 0.28
                      ? Curves.easeOut.transform(timeline / 0.28)
                      : 1.0 -
                            Curves.easeIn.transform(
                              (timeline - 0.28) / 0.72,
                            );
                  final clamped = intensity.clamp(0.0, 1.0);
                  final highlightColor = isMe
                      ? AC.yellowToolPanel
                      : AC.greenText1;
                  final maxBorderAlpha = isMe ? 0.92 : 0.34;
                  final borderAlpha = maxBorderAlpha * clamped;

                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: highlightColor.withValues(alpha: borderAlpha),
                        width: 2.7,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [bubbleBodyWithHighlight],
    );
  }

  Widget _buildBubbleBody(Message msg, double maxBubbleWidth) {
    final bubbleColor = msg.isSentByUser ? AC.greenStrong1 : AC.greyTab1;
    final textColor = msg.isSentByUser ? AC.white : AC.neutralChatHeader;
    final timeColor = msg.isSentByUser ? Colors.white70 : AC.neutralLoadingText;
    final timeLabel = _timeFormatter.format(msg.timestamp);

    if (msg.text == '__PRODUCTS__' && msg.products != null) {
      return ChatProductsBubble(
        products: msg.products ?? const <Product>[],
        maxWidth: maxBubbleWidth,
        backgroundColor: bubbleColor,
        timeLabel: timeLabel,
        timeColor: timeColor,
      );
    }

    if (msg.imageUrls != null && msg.imageUrls!.isNotEmpty) {
      return ChatImagesBubble(
        imageUrls: msg.imageUrls ?? const <String>[],
        maxWidth: maxBubbleWidth,
        backgroundColor: bubbleColor,
        onTapImage: (url) => _showImageFullscreen(url, msg.imageUrls ?? []),
        timeLabel: timeLabel,
        timeColor: timeColor,
        caption: msg.text.isNotEmpty && msg.text != '__IMAGES__'
            ? msg.text
            : null,
        captionColor: textColor,
      );
    }

    return ChatTextBubble(
      text: msg.text,
      timeLabel: timeLabel,
      maxWidth: maxBubbleWidth,
      backgroundColor: bubbleColor,
      textColor: textColor,
      timeColor: timeColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messagesAsync = ref.watch(nannyMessagesProvider);
    final isTyping = ref.watch(nannyTypingProvider);
    final hasUserMessagedRecently = ref.watch(
      nannyHasUserMessagedRecentlyProvider,
    );

    final messagesContent = messagesAsync.when(
      data: (messages) {
        _scheduleInitialScrollAndReveal();
        final showWelcomeBubble = !hasUserMessagedRecently;
        final showTypingRow = isTyping;

        if (messages.isEmpty && !showTypingRow && !showWelcomeBubble) {
          return _NannyEmptyState(onRefresh: _onRefresh);
        }

        final itemCount =
            messages.length +
            (showTypingRow ? 1 : 0) +
            (showWelcomeBubble ? 1 : 0);

        return RefreshIndicator(
          color: AC.greenStrong1,
          backgroundColor: AC.white,
          onRefresh: _onRefresh,
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
              SC.sw(16),
              SC.sh(24),
              SC.sw(16),
              SC.sh(16),
            ),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: itemCount,
            separatorBuilder: (_, __) => SizedBox(height: SC.sh(16)),
            itemBuilder: (context, index) {
              if (index < messages.length) {
                final messageKey = _messageKeyFor(messages[index].id);
                final messageWidget = _buildMessageBubble(
                  context,
                  messages,
                  index,
                );
                final wrapped = messageKey == null
                    ? messageWidget
                    : KeyedSubtree(key: messageKey, child: messageWidget);
                return FadeInWrapper(child: wrapped);
              }

              var tailIndex = messages.length;
              if (showTypingRow && index == tailIndex) {
                return const _NannyTypingRow();
              }
              if (showTypingRow) tailIndex += 1;

              // Welcome bubble is always the very last item in the conversation.
              if (showWelcomeBubble && index == tailIndex) {
                return _NannyWelcomeInline(
                  isLoadingWelcome: _isLoadingWelcome,
                  welcomeContent: _welcomeContent,
                  errorMessage: _welcomeError,
                  onRetryWelcome: () {
                    unawaited(_fetchNannyWelcomeContent(forceRefresh: true));
                  },
                  onSuggestionTap: _onSuggestionTap,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
      loading: () => const ChatMessagesLoadingState(),
      error: (error, __) {
        _scheduleInitialScrollAndReveal();
        return ChatMessagesErrorState(
          message: error.toString(),
          onRetry: _onRefresh,
        );
      },
    );

    return ChatScreenShell(
      hideAssistantFab: _contract.hidesAssistantFab,
      showHeader: false,
      onGlobalPointerDown: _handleGlobalPointerDown,
      contentFade: _presentationController.fade,
      headerTitle: '',
      headerBody: const SizedBox.shrink(),
      messagesContent: messagesContent,
      attachmentSection: _pendingAttachmentUrls.isNotEmpty
          ? ChatAttachmentPreview(
              urls: _pendingAttachmentUrls,
              onRemove: _removePendingAttachmentAt,
            )
          : null,
      composer: AssistantChatInputGroup(
        key: _inputGroupKey,
        controller: _controller,
        hintText: 'Hỏi, tìm kiếm thông tin các bé',
        isSending: _isSending || _isUploadingImage,
        onSendText: _handleSendText,
        onTapCamera: _onTapCamera,
        onTapImage: _onTapImage,
      ),
      showToolPanel: false,
      toolPanel: const SizedBox.shrink(),
      bottomInsetHeight: SC.sh(MQ.bottomPadding(context)),
      bottomBarColorWhenToolPanelShown: AC.white,
      bottomBarColorWhenToolPanelHidden: AC.white,
      showInitialLoadingOverlay:
          !_presentationController.hasShownInitialContent,
      initialLoadingText: l10n.chatNewLoadingConversation,
    );
  }
}

class _NannyEmptyState extends StatelessWidget {
  const _NannyEmptyState({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AC.greenStrong1,
      backgroundColor: AC.white,
      onRefresh: onRefresh,
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(16),
          vertical: SC.sh(24),
        ),
        children: [
          SizedBox(height: SC.sh(8)),
          Center(
            child: Text(
              'Hãy bắt đầu trò chuyện với Nanny',
              style: TextStyle(
                fontSize: SC.sf(14),
                color: AC.neutralLoadingText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NannyTypingRow extends StatelessWidget {
  const _NannyTypingRow();

  @override
  Widget build(BuildContext context) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.7;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBubbleWidth),
          child: ChatTextBubble(
            text: 'Nanny đang nhập...',
            timeLabel: '',
            maxWidth: maxBubbleWidth,
            backgroundColor: AC.greyTab1,
            textColor: AC.neutralChatHeader,
            timeColor: AC.neutralLoadingText,
          ),
        ),
      ],
    );
  }
}

class _NannyWelcomeInline extends StatelessWidget {
  const _NannyWelcomeInline({
    required this.onRetryWelcome,
    required this.isLoadingWelcome,
    required this.welcomeContent,
    required this.errorMessage,
    required this.onSuggestionTap,
  });

  final VoidCallback onRetryWelcome;
  final bool isLoadingWelcome;
  final NannyWelcomeContent? welcomeContent;
  final String? errorMessage;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (isLoadingWelcome) {
      body = SizedBox(
        height: SC.sh(200),
        child: Center(
          child: Text(
            'Đang tải gợi ý...',
            style: TextStyle(fontSize: SC.sf(14), color: AC.neutralLoadingText),
          ),
        ),
      );
    } else if (welcomeContent != null) {
      body = _NannyWelcomeBubble(
        content: welcomeContent!,
        onSuggestionTap: onSuggestionTap,
      );
    } else {
      body = ChatWelcomeError(
        message: errorMessage ?? 'Không tải được nội dung gợi ý',
        onRetry: onRetryWelcome,
        l10n: AppLocalizations.of(context)!,
      );
    }

    return body;
  }
}

class _NannyWelcomeBubble extends StatelessWidget {
  const _NannyWelcomeBubble({
    required this.content,
    required this.onSuggestionTap,
  });

  final NannyWelcomeContent content;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            content.title,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
              fontSize: SC.sf(16),
              height: 24 / 16,
              color: AC.neutralPrimaryText,
            ),
          ),
        ),
        SizedBox(height: SC.sh(18)),
        if (content.suggestions.isNotEmpty)
          Wrap(
            spacing: SC.sw(12),
            runSpacing: SC.sh(12),
            children: content.suggestions
                .map(
                  (text) => ChatWelcomeSuggestionChip(
                    label: text,
                    onTap: () => onSuggestionTap(text),
                  ),
                )
                .toList(growable: false),
          ),
      ],
    );
  }
}
