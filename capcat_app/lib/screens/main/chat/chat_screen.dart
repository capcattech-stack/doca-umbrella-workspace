import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capcat_doca/screens/main/chat/shared/controller/chat_presentation_controller.dart';
import 'package:capcat_doca/screens/main/chat/shared/models/chat_view_contracts.dart';
import 'package:capcat_doca/screens/main/chat/shared/chat_screen_contract.dart';
import 'package:capcat_doca/screens/main/chat/shared/chat_screen_entry_source.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_attachment_preview.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_avatar.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_input_group.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_rich_bubbles.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_text_bubble.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_tool_panel.dart';
import 'package:capcat_doca/screens/main/chat/shared/message_actions/chat_message_actions_resolver.dart';
import 'package:capcat_doca/screens/main/chat/shared/message_actions/chat_message_actions_sheet.dart';
import 'package:capcat_doca/screens/main/chat/shared/sections/chat_message_states_section.dart';
import 'package:capcat_doca/screens/main/chat/shared/sections/chat_screen_shell.dart';
import 'package:capcat_doca/screens/main/chat/tools/zodiac_screen.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:capcat_doca/models/chat_welcome.dart';
import 'package:capcat_doca/models/conversation.dart';
import 'package:capcat_doca/models/message.dart';
import 'package:capcat_doca/providers/conversation_messages_provider.dart';
import 'package:capcat_doca/providers/socket_provider.dart';
import 'package:capcat_doca/services/chat_attachment_service.dart';
import 'package:capcat_doca/services/chat_welcome_remote_service.dart';
import 'package:capcat_doca/services/image_picker_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/route_observer.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/fade_in_wrapper.dart';
import 'package:capcat_doca/screens/main/chat/tools/numerology_screen.dart';
import 'package:capcat_doca/screens/main/chat/tools/create_content_screen.dart';
import 'package:capcat_doca/screens/main/chat/chat_thread_screen.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/widgets/viewer/full_screen_gallery_viewer.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.conversation,
    this.entrySource = ChatScreenEntrySource.standard,
  });

  final Conversation conversation;
  final ChatScreenEntrySource entrySource;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with TickerProviderStateMixin, RouteAware {
  io.Socket? _socket;
  ProviderSubscription<AsyncValue<io.Socket?>>? _socketSubscription;
  late final StreamSubscription<bool> _keyboardSubscription;
  final DateFormat _timeFormatter = DateFormat('HH:mm');
  // final FocusNode _focusNode = FocusNode();

  final List<Message> _pendingMessages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _pendingAttachmentUrls = [];
  late final ChatPresentationController _presentationController;
  bool _isUploadingImage = false;
  bool _hasAutoScrolled = false;
  bool _skipRefreshOnPopNext = false;
  final GlobalKey _toolPanelKey = GlobalKey();
  final GlobalKey _inputGroupKey = GlobalKey();
  bool _isKeyboardVisible = false;
  ChatWelcomeContent? _welcomeContent;
  bool _isLoadingWelcomeContent = false;
  String? _welcomeError;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _presentationController = ChatPresentationController(vsync: this);

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   // _applyChatSystemUiStyle();
    //   // _applyToolPanelNavigationColor();
    // });

    // Theo dõi sự kiện keyboard
    _keyboardSubscription = KeyboardVisibilityController().onChange.listen((
      bool visible,
    ) {
      _isKeyboardVisible = visible;
      if (visible) {
        if (_presentationController.showToolPanel) {
          _hideToolPanel();
        }
        // _scrollToBottomRepeatedly();
        _ensureLatestMessagesVisible(300);
      }
    });
    _scrollController.addListener(_clampScrollBounds);

    _socketSubscription = ref.listenManual<AsyncValue<io.Socket?>>(
      socketProvider,
      (previous, next) {
        next.whenData((socket) {
          if (socket == null) {
            _detachSocket();
          } else {
            _attachSocket(socket);
          }
        });
      },
      fireImmediately: true,
    );
    _fetchChatWelcomeContent();

    // _focusNode.addListener(() {
    //   if (_focusNode.hasFocus) {
    //     //_scrollToBottomRepeatedly(500, 100);
    //     _scrollToBottomRepeatedly(500, 50);
    //     Future.delayed(const Duration(milliseconds: 500), () {
    //       _scrollToBottom(600);
    //     });
    //   }
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    if (_skipRefreshOnPopNext) {
      _skipRefreshOnPopNext = false;
      return;
    }
    _resetRevealState();
    unawaited(
      _refreshMessages().then((_) {
        if (!mounted) return;
        _scheduleInitialScrollAndReveal();
      }),
    );
  }

  ConversationMessagesArgs get _messageArgs => (
    conversationId: widget.conversation.id,
    parentId: _contract.parentId,
    currentAccountId: widget.conversation.userAccountId,
  );

  ChatScreenContract get _contract => ChatScreenContracts.conversation;

  ChatComposerViewData _buildComposerViewData(AppLocalizations l10n) {
    return ChatComposerViewData(
      isSendDisabled: _isUploadingImage,
      isToolPanelEnabled: _contract.hasToolPanel,
      isToolPanelVisible:
          _contract.hasToolPanel && _presentationController.showToolPanel,
      hasPendingAttachments: _pendingAttachmentUrls.isNotEmpty,
      hintText: l10n.chatNewInputHint,
    );
  }

  ChatComposerActions _buildComposerActions() {
    return ChatComposerActions(
      onToggleTools: _contract.hasToolPanel ? _toggleToolPanel : () {},
      onSendText: _sendMessage,
    );
  }

  ChatToolPanelActions _buildToolPanelActions() {
    return ChatToolPanelActions(
      onSendImage: _handlePickImagesFromTools,
      onTapNumerology: _openNumerologyScreen,
      onTapConstellation: _openConstellationScreen,
      onTapCreateContent: _openCreateContentScreen,
    );
  }

  bool get _isAssistantEntry =>
      widget.entrySource == ChatScreenEntrySource.assistantFab;

  String _resolveConversationTitle(AppLocalizations l10n) {
    final title = widget.conversation.title.trim();
    if (title.isNotEmpty) return title;
    return l10n.chatLandingConversationTitle;
  }

  List<Message> _mergeMessages(List<Message> remoteMessages) {
    if (_pendingMessages.isEmpty) return remoteMessages;
    return [...remoteMessages, ..._pendingMessages];
  }

  void _maybeAutoScroll(List<Message> remoteMessages) {
    if (_hasAutoScrolled || remoteMessages.isEmpty) return;
    _hasAutoScrolled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _refreshMessages() {
    return ref
        .read(conversationMessagesProvider(_messageArgs).notifier)
        .refresh();
  }

  void _attachSocket(io.Socket socket) {
    if (_socket == socket) return;
    _detachSocket();
    _socket = socket;
    _registerSocketHandlers(socket);
  }

  void _detachSocket() {
    _socket?.off('server-messaging', _handleServerMessaging);
    _socket?.off('server-messages', _handleServerMessages);
    _socket?.off('exception', _handleSocketException);
    _socket = null;
  }

  void _clampScrollBounds() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final max = position.maxScrollExtent;
    if (position.pixels > max) {
      _scrollController.jumpTo(max);
    }
  }

  Future<void> _fetchChatWelcomeContent() async {
    setState(() {
      _isLoadingWelcomeContent = true;
      _welcomeError = null;
    });
    final response = await ChatWelcomeRemoteService.getWelcomeContent();
    if (!mounted) return;
    if (response.isSuccess && response.data != null) {
      setState(() {
        _welcomeContent = response.data;
        _isLoadingWelcomeContent = false;
        _welcomeError = null;
      });
    } else {
      setState(() {
        _welcomeError =
            response.message ??
            AppLocalizations.of(context)!.chatNewSuggestionErrorWithRetry;
        _isLoadingWelcomeContent = false;
      });
    }
  }

  void _handleWelcomeSuggestionTap(String suggestion) {
    final trimmed = suggestion.trim();
    if (trimmed.isEmpty) return;
    _controller
      ..text = trimmed
      ..selection = TextSelection.collapsed(offset: trimmed.length);
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

  void _toggleToolPanel() {
    if (!_contract.hasToolPanel) return;
    final shouldShow = _presentationController.toggleToolPanel(
      isKeyboardVisible: _isKeyboardVisible,
      unfocusKeyboard: () => FocusScope.of(context).unfocus(),
    );
    setState(() {});
    // _applyToolPanelNavigationColor();
    if (shouldShow) {
      _ensureLatestMessagesVisible(150);
    }
  }

  void _hideToolPanel() {
    if (!_presentationController.hideToolPanel()) return;
    setState(() {});
    // _applyToolPanelNavigationColor();
  }

  void _ensureLatestMessagesVisible(int durationMs) {
    Future.delayed(Duration(milliseconds: durationMs), () {
      if (!mounted) return;
      _scrollToBottom(300);
    });
  }

  void _resetRevealState() {
    _presentationController.resetRevealState();
    if (mounted) {
      setState(() {});
    }
  }

  // void _applyToolPanelNavigationColor() {
  //   ColorUtil.applySafeAreaColor(
  //     navigationBarColor: _showToolPanel
  //         ? AC.yellowToolPanel
  //         : AC.yellowChatInputGroup,
  //   );
  // }

  bool _isPointInside(GlobalKey key, Offset globalPoint) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return false;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    return rect.contains(globalPoint);
  }

  void _handleGlobalPointerDown(PointerDownEvent event) {
    if (_isPointInside(_toolPanelKey, event.position)) return;
    if (_isPointInside(_inputGroupKey, event.position)) return;

    _hideToolPanel();

    if (_isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _handlePickImagesFromTools() async {
    _skipRefreshOnPopNext = true;
    final picked = await ImagePickerService.pickImages(context);
    _skipRefreshOnPopNext = false;
    final paths = picked?.paths ?? [];
    if (!mounted) return;
    if (paths.isNotEmpty) {
      _handleImageSelection(paths);
    }
    _hideToolPanel();
  }

  void _openNumerologyScreen() {
    _openToolScreen(
      NumerologyScreen(
        conversationId: widget.conversation.id,
        conversationTitle: widget.conversation.title,
        conversationAvatarUrl: widget.conversation.avatarUrl,
      ),
    );
  }

  void _openConstellationScreen() {
    _openToolScreen(
      ZodiacScreen(
        conversationId: widget.conversation.id,
        conversationTitle: widget.conversation.title,
        conversationAvatarUrl: widget.conversation.avatarUrl,
      ),
    );
  }

  void _openCreateContentScreen() {
    _openToolScreen(
      CreateContentScreen(
        conversationId: widget.conversation.id,
        conversationTitle: widget.conversation.title,
        conversationAvatarUrl: widget.conversation.avatarUrl,
      ),
    );
  }

  void _openToolScreen(Widget screen) {
    _hideToolPanel();
    // ColorUtil.applySafeAreaColor(navigationBarColor: Colors.white);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen)).then((
      result,
    ) {
      // ColorUtil.applySafeAreaColor(navigationBarColor: AC.yellowChatInputGroup);
      // if (result == true) {
      //   unawaited(
      //     _refreshMessages().then((_) {
      //       if (!mounted) return;
      //       _scrollToBottomRepeatedly();
      //     }),
      //   );
      // }
    });
  }

  void _registerSocketHandlers(io.Socket socket) {
    socket
      ..off('server-messaging', _handleServerMessaging)
      ..off('server-messages', _handleServerMessages)
      ..off('exception', _handleSocketException);
    socket.on('server-messaging', _handleServerMessaging);
    socket.on('server-messages', _handleServerMessages);
    socket.on('exception', _handleSocketException);
  }

  void _handleServerMessaging(dynamic data) {
    debugPrint('ℹ️ server-messaging: $data');
  }

  void _handleServerMessages(dynamic data) {
    if (data is Iterable) {
      for (final item in data) {
        _ingestIncomingPayload(item);
      }
    } else {
      _ingestIncomingPayload(data);
    }
  }

  void _handleSocketException(dynamic data) {
    debugPrint('⚠️ Socket exception: $data');
  }

  void _ingestIncomingPayload(dynamic payload) {
    if (!mounted) return;
    final message = _parseIncomingMessage(payload);
    if (message == null) return;
    if (message.parentId != null) {
      // Reply messages belong to a thread; they shouldn't appear in main chat list.
      return;
    }
    setState(() => _pendingMessages.add(message));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(600);
    });
  }

  Message? _parseIncomingMessage(dynamic data, {bool fromSelf = false}) {
    if (data is Map<String, dynamic>) {
      try {
        return Message.fromJson(
          data,
          currentAccountId: widget.conversation.userAccountId,
        );
      } catch (e) {
        debugPrint('⚠️ Failed to parse incoming message: $e');
      }
    }
    final text = data?.toString();
    if (text == null || text.isEmpty) return null;
    return Message(text: text, isSentByUser: fromSelf);
  }

  void _sendMessage(String text) {
    if (_isUploadingImage) {
      _showToast(AppLocalizations.of(context)!.chatNewUploadingImage);
      return;
    }
    final trimmed = text.trim();
    final hasAttachments = _pendingAttachmentUrls.isNotEmpty;
    if (trimmed.isEmpty && !hasAttachments) {
      // _showToast('Vui lòng nhập nội dung hoặc chọn ảnh.');
      return;
    }
    final attachmentCopy = hasAttachments
        ? List<String>.from(_pendingAttachmentUrls)
        : null;
    _emitUserMessage(content: trimmed, imageUrls: attachmentCopy);
    _controller.clear();
    if (hasAttachments) {
      setState(() => _pendingAttachmentUrls.clear());
    }
  }

  void _emitUserMessage({required String content, List<String>? imageUrls}) {
    final socket = _socket;
    if (socket == null) {
      debugPrint('⚠️ Cannot emit message without socket connection');
      return;
    }
    if (!socket.connected) {
      socket.connect();
    }

    if (content.isEmpty &&
        (imageUrls == null ||
            imageUrls.where((url) => url.startsWith('http')).isEmpty)) {
      debugPrint('⚠️ Skip sending empty payload');
      return;
    }

    final messagePayload = <String, dynamic>{'content': content};
    Map<String, dynamic>? richContent;
    if (imageUrls != null && imageUrls.isNotEmpty) {
      final remoteUrls = imageUrls
          .where((url) => url.startsWith('http'))
          .toList(growable: false);
      if (remoteUrls.isNotEmpty) {
        if (remoteUrls.length == 1) {
          richContent = {'type': 'image', 'url': remoteUrls.first};
        } else {
          richContent = {'type': 'images', 'urls': remoteUrls};
          debugPrint('');
        }
      }
    }
    if (richContent != null) {
      messagePayload['rich_content'] = richContent;
    }

    final payload = {
      'conversation_id': widget.conversation.id,
      'message': messagePayload,
    };

    socket.emit('user-messages', payload);

    List<String>? previewUrls;
    if (richContent != null) {
      if (richContent['type'] == 'image' && richContent['url'] is String) {
        previewUrls = [richContent['url'] as String];
      } else if (richContent['type'] == 'images' &&
          richContent['urls'] is List) {
        previewUrls = List<String>.from(richContent['urls'] as List);
      }
    } else {
      previewUrls = imageUrls;
    }

    setState(
      () => _pendingMessages.add(
        Message(text: content, isSentByUser: true, imageUrls: previewUrls),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(600);
    });
  }

  void _handleImageSelection(List<String> paths) {
    unawaited(_processImageSelection(paths));
  }

  Future<void> _processImageSelection(List<String> paths) async {
    if (paths.isEmpty) return;

    if (_isUploadingImage) {
      _showToast(AppLocalizations.of(context)!.chatNewUploadingAnotherImage);
      return;
    }

    setState(() => _isUploadingImage = true);
    try {
      // if (paths.length == 1) {
      //   final uploadResult = await ChatAttachmentService.uploadSingleImage(
      //     conversationId: widget.conversation.id,
      //     imagePath: paths.first,
      //   );

      //   if (!mounted) return;

      //   if (uploadResult.isSuccess && uploadResult.data != null) {
      //     _addPendingAttachments([uploadResult.data!]);
      //   } else {
      //     _showSnackBar(
      //       uploadResult.message ?? 'Gửi ảnh thất bại, vui lòng thử lại.',
      //     );
      //   }
      // } else {
      final uploadResult = await ChatAttachmentService.uploadMultipleImages(
        conversationId: widget.conversation.id,
        imagePaths: paths,
      );

      if (!mounted) return;

      if (uploadResult.isSuccess && uploadResult.data != null) {
        _addPendingAttachments(uploadResult.data!);
      } else {
        _showToast(
          uploadResult.message ??
              AppLocalizations.of(context)!.chatNewUploadFailed,
        );
      }
      // }
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  void _showToast(String message) {
    if (!mounted) return;
    ToastOverlay.show(context, message);
  }

  void _addPendingAttachments(List<String> urls) {
    if (urls.isEmpty) return;
    setState(() => _pendingAttachmentUrls.addAll(urls));
  }

  void _removePendingAttachmentAt(int index) {
    if (index < 0 || index >= _pendingAttachmentUrls.length) return;
    setState(() => _pendingAttachmentUrls.removeAt(index));
  }

  void _showImageFullscreen(String imageUrl, List<String> allImages) {
    _skipRefreshOnPopNext = true;
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
    ).whenComplete(() {
      _skipRefreshOnPopNext = false;
    });
  }

  void _scrollToBottom(int milliseconds) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
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
      }
    });
  }

  void _scrollToBottomLinear(int milliseconds) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: milliseconds),
          curve: Curves.linear,
        );
      }
    });
  }

  void _scrollToBottomRepeatedly() {
    const stepDuration = 150;

    void performStep() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        final remaining =
            _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels;
        if (remaining <= 1) return;

        _scrollToBottomLinear(stepDuration);
        Future.delayed(const Duration(milliseconds: stepDuration), performStep);
      });
    }

    _scrollToBottomLinear(stepDuration);
    Future.delayed(const Duration(milliseconds: stepDuration), performStep);
  }

  bool _shouldShowAvatar(List<Message> messages, int index) {
    final msg = messages[index];
    if (msg.isSentByUser) return false;
    if (index == 0) return true;
    return messages[index - 1].isSentByUser;
  }

  Widget _buildMessageBubble(
    BuildContext context,
    List<Message> messages,
    int index,
  ) {
    final msg = messages[index];
    final bool isMe = msg.isSentByUser;
    final bool showAvatar = !isMe && _shouldShowAvatar(messages, index);
    final String? avatarUrl =
        msg.sender?.avatar ?? widget.conversation.avatarUrl;

    final double maxBubbleWidth =
        MediaQuery.of(context).size.width * 0.7; // shrink-to-fit trần
    final actions = resolveChatMessageActions(
      kind: _contract.kind,
      message: msg,
    );
    final bubbleBody = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxBubbleWidth),
      child: _buildBubbleBody(msg, maxBubbleWidth),
    );
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

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar cho bên trái
        if (!isMe)
          Padding(
            padding: EdgeInsets.only(right: SC.sw(8)),
            child: showAvatar
                ? ChatAvatar(avatarUrl: avatarUrl)
                : SizedBox(width: SC.sw(32)),
          ),

        // ⭐ KHÔNG DÙNG Flexible – KHÔNG ép full width
        bubbleBodyWithLongPress,
      ],
    );
  }

  Widget _buildBubbleBody(Message msg, double maxBubbleWidth) {
    final Color incomingBackground = AC.greyTab1;
    final Color outgoingBackground = AC.greenStrong1;

    final Color bubbleColor = msg.isSentByUser
        ? outgoingBackground
        : incomingBackground;

    final Color textColor = msg.isSentByUser
        ? Colors.white
        : AC.neutralChatHeader;

    final Color timeColor = msg.isSentByUser
        ? Colors.white70
        : AC.neutralLoadingText;

    final String timeLabel = _timeFormatter.format(msg.timestamp);

    // Sản phẩm
    if (msg.text == '__PRODUCTS__' && msg.products != null) {
      return ChatProductsBubble(
        products: msg.products!,
        maxWidth: maxBubbleWidth,
        backgroundColor: bubbleColor,
        timeLabel: timeLabel,
        timeColor: timeColor,
      );
    }

    // Hình ảnh
    if (msg.imageUrls != null && msg.imageUrls!.isNotEmpty) {
      return ChatImagesBubble(
        imageUrls: msg.imageUrls!,
        maxWidth: maxBubbleWidth,
        backgroundColor: bubbleColor,
        onTapImage: (url) => _showImageFullscreen(url, msg.imageUrls!),
        timeLabel: timeLabel,
        timeColor: timeColor,
        caption: msg.text.isNotEmpty && msg.text != '__IMAGES__'
            ? msg.text
            : null,
        captionColor: textColor,
      );
    }

    // Tin nhắn text
    final canShowThreadReplies = _contract.supportsThreadReplies;
    return ChatTextBubble(
      text: msg.text,
      timeLabel: timeLabel,
      maxWidth: maxBubbleWidth,
      backgroundColor: bubbleColor,
      textColor: textColor,
      timeColor: timeColor,
      replyCount: msg.replyCount,
      showThreadButton: canShowThreadReplies && (msg.isThreadRoot ?? false),
      onSeeMore:
          canShowThreadReplies && (msg.isThreadRoot ?? false) && msg.id != null
          ? () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatThreadScreen(
                    conversation: widget.conversation,
                    rootMessageId: msg.id!,
                  ),
                ),
              );
              // if (!mounted) return;
              // _contentFadeController?.reset();
              // _hasShownInitialContent = false;
              // _hasPerformedInitialScroll = false;
              // _initialScrollScheduled = false;
              // unawaited(
              //   _refreshMessages().then((_) {
              //     if (!mounted) return;
              //     _scheduleInitialScrollAndReveal();
              //   }),
              // );
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final conversationTitle = _resolveConversationTitle(l10n);
    final messagesAsync = ref.watch(conversationMessagesProvider(_messageArgs));
    final composerData = _buildComposerViewData(l10n);
    final composerActions = _buildComposerActions();
    final toolPanelActions = _buildToolPanelActions();

    final messagesContent = messagesAsync.when(
      data: (remoteMessages) {
        _scheduleInitialScrollAndReveal();
        final mergedMessages = _mergeMessages(remoteMessages);
        if (mergedMessages.isEmpty) {
          if (!_contract.hasWelcomeContent) {
            return const SizedBox.shrink();
          }
          return ChatWelcomeState(
            onRefreshMessages: _refreshMessages,
            onRetryWelcome: _fetchChatWelcomeContent,
            welcomeContent: _welcomeContent,
            isLoadingWelcome: _isLoadingWelcomeContent,
            errorMessage: _welcomeError,
            onSuggestionTap: _handleWelcomeSuggestionTap,
            l10n: l10n,
          );
        }
        return ListView.separated(
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
          itemCount: mergedMessages.length,
          separatorBuilder: (_, __) => SizedBox(height: SC.sh(16)),
          itemBuilder: (context, index) {
            final messageWidget = _buildMessageBubble(
              context,
              mergedMessages,
              index,
            );
            return FadeInWrapper(child: messageWidget);
          },
        );
      },
      loading: () => const ChatMessagesLoadingState(),
      error: (error, __) {
        _scheduleInitialScrollAndReveal();
        return ChatMessagesErrorState(
          message: error.toString(),
          onRetry: _refreshMessages,
        );
      },
    );

    final attachmentSection =
        (_pendingAttachmentUrls.isNotEmpty || _isUploadingImage)
        ? Padding(
            padding: EdgeInsets.fromLTRB(
              SC.sw(16),
              SC.sh(8),
              SC.sw(16),
              SC.sh(4),
            ),
            child: Container(
              padding: EdgeInsets.all(SC.smin(8)),
              decoration: BoxDecoration(
                color: AC.whiteOverlay20,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isUploadingImage)
                    Padding(
                      padding: EdgeInsets.only(bottom: SC.sh(8)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.hourglass_bottom,
                            size: SC.smin(16),
                            color: AppColors.greenStrong1,
                          ),
                          SizedBox(width: SC.sw(8)),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.chatNewUploadingImageShort,
                            style: TextStyle(
                              fontSize: SC.sf(12),
                              color: AC.neutralChatSubtext,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_pendingAttachmentUrls.isNotEmpty)
                    ChatAttachmentPreview(
                      urls: _pendingAttachmentUrls,
                      onRemove: _removePendingAttachmentAt,
                    ),
                ],
              ),
            ),
          )
        : null;

    final headerBody = Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatAvatar(
            avatarUrl: widget.conversation.avatarUrl,
            size: SC.smin(40),
          ),
          SizedBox(width: SC.sw(8)),
          Text(
            conversationTitle,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
              fontSize: SC.sf(16),
              height: 22 / 16,
              color: AC.blackText5,
            ),
          ),
          if (_isAssistantEntry) ...[
            SizedBox(width: SC.sw(6)),
            Icon(
              Icons.auto_awesome_rounded,
              size: SC.smin(14),
              color: AC.greenText1,
            ),
          ],
        ],
      ),
    );

    return ChatScreenShell(
      hideAssistantFab: _contract.hidesAssistantFab,
      onGlobalPointerDown: _handleGlobalPointerDown,
      contentFade: _presentationController.fade,
      headerTitle: conversationTitle,
      headerBody: headerBody,
      messagesContent: messagesContent,
      attachmentSection: attachmentSection,
      composer: ChatInputGroup(
        key: _inputGroupKey,
        controller: _controller,
        data: composerData,
        actions: composerActions,
      ),
      showToolPanel:
          _contract.hasToolPanel && _presentationController.showToolPanel,
      toolPanel: ChatToolPanel(
        key: _toolPanelKey,
        actions: toolPanelActions,
        l10n: l10n,
      ),
      bottomInsetHeight: SC.sh(MQ.bottomPadding(context)),
      bottomBarColorWhenToolPanelShown: AC.yellowToolPanel,
      bottomBarColorWhenToolPanelHidden: AC.yellowChatInputGroup,
      showInitialLoadingOverlay:
          !_presentationController.hasShownInitialContent,
      initialLoadingText: AppLocalizations.of(
        context,
      )!.chatNewLoadingConversation,
    );
  }

  @override
  void dispose() {
    // _restoreSystemUiStyle();
    // ColorUtil.restoreSafeAreaColor();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    routeObserver.unsubscribe(this);
    _socketSubscription?.close();
    _keyboardSubscription.cancel();
    _scrollController.removeListener(_clampScrollBounds);
    _controller.dispose();
    _scrollController.dispose();
    _presentationController.dispose();
    _detachSocket();
    super.dispose();
  }

  // void _applyChatSystemUiStyle() {
  //   SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       systemNavigationBarColor: AC.yellowChatInputGroup,
  //       systemNavigationBarIconBrightness: Brightness.dark,
  //       statusBarColor: Colors.transparent,
  //       statusBarIconBrightness: Brightness.dark,
  //     ),
  //   );
  // }

  // void _restoreSystemUiStyle() {
  //   SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       systemNavigationBarColor: Colors.transparent,
  //       systemNavigationBarIconBrightness: Brightness.dark,
  //       statusBarColor: Colors.transparent,
  //       statusBarIconBrightness: Brightness.dark,
  //     ),
  //   );
  // }
}
