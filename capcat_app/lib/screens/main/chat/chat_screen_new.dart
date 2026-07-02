import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capcat_doca/screens/main/chat/tools/zodiac_screen.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:capcat_doca/models/chat_welcome.dart';
import 'package:capcat_doca/models/conversation.dart';
import 'package:capcat_doca/models/message.dart';
import 'package:capcat_doca/models/product.dart';
import 'package:capcat_doca/providers/conversation_messages_provider.dart';
import 'package:capcat_doca/providers/socket_provider.dart';
import 'package:capcat_doca/services/chat_attachment_service.dart';
import 'package:capcat_doca/services/chat_welcome_remote_service.dart';
import 'package:capcat_doca/services/image_picker_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/route_observer.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/fade_in_wrapper.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/product_item.dart';
import 'package:capcat_doca/screens/main/chat/tools/numerology_screen.dart';
import 'package:capcat_doca/screens/main/chat/tools/create_content_screen.dart';
import 'package:capcat_doca/screens/main/chat/chat_thread_screen.dart';
import 'package:capcat_doca/widgets/image/rectangle_cached_network_image.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/widgets/loading/text_loading_indicator.dart';
import 'package:capcat_doca/widgets/viewer/full_screen_gallery_viewer.dart';

enum ChatScreenEntrySourceOld { standard, assistantFab }

class ChatScreenNew extends ConsumerStatefulWidget {
  const ChatScreenNew({
    super.key,
    required this.conversation,
    this.entrySource = ChatScreenEntrySourceOld.standard,
  });

  final Conversation conversation;
  final ChatScreenEntrySourceOld entrySource;

  @override
  ConsumerState<ChatScreenNew> createState() => _ChatScreenNewState();
}

class _ChatScreenNewState extends ConsumerState<ChatScreenNew>
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
  bool _isUploadingImage = false;
  bool _hasAutoScrolled = false;
  bool _hasPerformedInitialScroll = false;
  AnimationController? _contentFadeController;
  Animation<double> _contentFade = const AlwaysStoppedAnimation(0);
  bool _hasShownInitialContent = false;
  bool _initialScrollScheduled = false;
  bool _skipRefreshOnPopNext = false;
  bool _showToolPanel = false;
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
        if (_showToolPanel) {
          _hideToolPanel();
        }
        // _scrollToBottomRepeatedly();
        _ensureLatestMessagesVisible(300);
      }
    });
    _contentFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _contentFade = CurvedAnimation(
      parent: _contentFadeController!,
      curve: Curves.easeOut,
    );
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
    parentId: null,
    currentAccountId: widget.conversation.userAccountId,
  );

  bool get _isAssistantEntry =>
      widget.entrySource == ChatScreenEntrySourceOld.assistantFab;

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
    if (_hasShownInitialContent || _initialScrollScheduled) return;
    _initialScrollScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasShownInitialContent) return;
      _jumpToLatestOnce();
      _revealChatContent();
    });
  }

  void _jumpToLatestOnce() {
    if (_hasPerformedInitialScroll) return;
    _hasPerformedInitialScroll = true;
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
    Future.delayed(const Duration(milliseconds: 80), () {
      if (!mounted || !_scrollController.hasClients) return;
      final remaining =
          _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (remaining > 1) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _revealChatContent() {
    if (_hasShownInitialContent) return;
    setState(() => _hasShownInitialContent = true);
    _contentFadeController?.forward();
  }

  void _toggleToolPanel() {
    final shouldShow = !_showToolPanel;
    if (shouldShow && _isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }
    setState(() => _showToolPanel = shouldShow);
    // _applyToolPanelNavigationColor();
    if (shouldShow) {
      _ensureLatestMessagesVisible(150);
    }
  }

  void _hideToolPanel() {
    if (!_showToolPanel) return;
    setState(() => _showToolPanel = false);
    // _applyToolPanelNavigationColor();
  }

  void _ensureLatestMessagesVisible(int durationMs) {
    Future.delayed(Duration(milliseconds: durationMs), () {
      if (!mounted) return;
      _scrollToBottom(300);
    });
  }

  void _resetRevealState() {
    _contentFadeController?.reset();
    _hasShownInitialContent = false;
    _hasPerformedInitialScroll = false;
    _initialScrollScheduled = false;
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

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar cho bên trái
        if (!isMe)
          Padding(
            padding: EdgeInsets.only(right: SC.sw(8)),
            child: showAvatar
                ? _ChatAvatar(avatarUrl: avatarUrl)
                : SizedBox(width: SC.sw(32)),
          ),

        // ⭐ KHÔNG DÙNG Flexible – KHÔNG ép full width
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBubbleWidth),
          child: _buildBubbleBody(msg, maxBubbleWidth),
        ),
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
      return _ProductsBubble(
        products: msg.products!,
        maxWidth: maxBubbleWidth,
        backgroundColor: bubbleColor,
        timeLabel: timeLabel,
        timeColor: timeColor,
      );
    }

    // Hình ảnh
    if (msg.imageUrls != null && msg.imageUrls!.isNotEmpty) {
      return _ImagesBubble(
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
    return _TextBubble(
      text: msg.text,
      timeLabel: timeLabel,
      maxWidth: maxBubbleWidth,
      backgroundColor: bubbleColor,
      textColor: textColor,
      timeColor: timeColor,
      replyCount: msg.replyCount,
      showThreadButton: msg.isThreadRoot ?? false,
      onSeeMore: (msg.isThreadRoot ?? false) && msg.id != null
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

    return AssistantVisibilityScope.hide(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: CustomScaffold(
          resizeToAvoidBottomInset: true,
          body: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _handleGlobalPointerDown,
            child: SafeAreaTopOnly(
              child: Stack(
                children: [
                  FadeTransition(
                    opacity: _contentFade,
                    child: Column(
                      children: [
                        CustomAppHeader(
                          title: conversationTitle,
                          body: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ChatAvatar(
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
                          ),
                          hasLeftAction: true,
                          color: AC.white,
                        ),
                        Expanded(
                          child: messagesAsync.when(
                            data: (remoteMessages) {
                              _scheduleInitialScrollAndReveal();
                              final mergedMessages = _mergeMessages(
                                remoteMessages,
                              );
                              if (mergedMessages.isEmpty) {
                                return _ChatWelcomeState(
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
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: SC.sh(16)),
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
                            loading: () => const _MessagesLoadingState(),
                            error: (error, __) {
                              _scheduleInitialScrollAndReveal();
                              return _MessagesErrorState(
                                message: error.toString(),
                                onRetry: _refreshMessages,
                              );
                            },
                          ),
                        ),
                        if (_pendingAttachmentUrls.isNotEmpty ||
                            _isUploadingImage)
                          Padding(
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
                                      padding: EdgeInsets.only(
                                        bottom: SC.sh(8),
                                      ),
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
                                    _PendingAttachmentPreview(
                                      urls: _pendingAttachmentUrls,
                                      onRemove: _removePendingAttachmentAt,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        _ChatInputGroup(
                          key: _inputGroupKey,
                          controller: _controller,
                          onSend: _sendMessage,
                          onPickImages: _handleImageSelection,
                          isSendDisabled: _isUploadingImage,
                          onToggleTools: _toggleToolPanel,
                          isToolPanelVisible: _showToolPanel,
                          hasPendingAttachments:
                              _pendingAttachmentUrls.isNotEmpty,
                          hintText: l10n.chatNewInputHint,
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOut,
                          alignment: Alignment.topCenter,
                          child: _showToolPanel
                              ? _ChatToolPanel(
                                  key: _toolPanelKey,
                                  onSendImage: _handlePickImagesFromTools,
                                  onTapNumerology: _openNumerologyScreen,
                                  onTapConstellation: _openConstellationScreen,
                                  onTapCreateContent: _openCreateContentScreen,
                                  l10n: l10n,
                                )
                              : const SizedBox.shrink(),
                        ),
                        Container(
                          color: _showToolPanel
                              ? AC.yellowToolPanel
                              : AC.yellowChatInputGroup,
                          height: SC.sh(MQ.bottomPadding(context)),
                        ),
                      ],
                    ),
                  ),
                  if (!_hasShownInitialContent)
                    Center(
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.chatNewLoadingConversation,
                        style: TextStyle(
                          fontSize: SC.sf(14),
                          color: AC.neutralLoadingText,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
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
    _contentFadeController?.dispose();
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

class _ChatToolPanel extends StatelessWidget {
  const _ChatToolPanel({
    super.key,
    required this.onSendImage,
    required this.onTapNumerology,
    required this.onTapConstellation,
    required this.onTapCreateContent,
    required this.l10n,
  });

  final VoidCallback onSendImage;
  final VoidCallback onTapNumerology;
  final VoidCallback onTapConstellation;
  final VoidCallback onTapCreateContent;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    Widget buildIcon(
      List<Color> colors,
      IconData icon, {
      Color iconColor = Colors.white,
    }) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: iconColor, size: SC.smin(24)),
      );
    }

    final options = <_ToolButtonData>[
      _ToolButtonData(
        title: l10n.chatNewSendImages,
        icon: Image.asset('assets/icons/chat-tool-send-images.png'),
        onTap: onSendImage,
      ),
      _ToolButtonData(
        title: l10n.chatNewToolNumerology,
        icon: Image.asset('assets/icons/chat-tool-than-so-hoc.png'),
        onTap: onTapNumerology,
      ),
      _ToolButtonData(
        title: l10n.chatNewToolZodiac,
        icon: Image.asset('assets/icons/chat-tool-mat-ngu-chom-sao.png'),
        captionMaxLines: 2,
        onTap: onTapConstellation,
      ),
      _ToolButtonData(
        title: l10n.chatNewToolCaption,
        icon: Image.asset('assets/icons/chat-tool-caption-hay-viral.png'),
        captionMaxLines: 2,
        onTap: onTapCreateContent,
      ),
      _ToolButtonData(
        title: l10n.chatNewToolDiary,
        icon: Image.asset('assets/icons/chat-tool-viet-nhat-ky.png'),
      ),
      _ToolButtonData(
        title: l10n.chatNewToolOilPainting,
        icon: Image.asset('assets/icons/chat-tool-ve-tranh-son-dau.png'),
        comingSoon: true,
        comingSoonLabel: l10n.chatNewToolComingSoon,
      ),
      _ToolButtonData(
        title: l10n.chatNewToolStudio,
        icon: Image.asset('assets/icons/chat-tool-chup-studio.png'),
        comingSoon: true,
        comingSoonLabel: l10n.chatNewToolComingSoon,
      ),
      _ToolButtonData(
        title: l10n.chatNewToolCompose,
        icon: Image.asset('assets/icons/chat-tool-sang-tac.png'),
        comingSoon: true,
        comingSoonLabel: l10n.chatNewToolComingSoon,
      ),
    ];

    return Container(
      width: double.infinity,
      color: AC.yellowToolPanel,
      padding: EdgeInsets.symmetric(horizontal: SC.sw(16), vertical: SC.sh(16)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: SC.sw(12),
          mainAxisSpacing: SC.sh(16),
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, index) => _ChatToolButton(data: options[index]),
      ),
    );
  }
}

class _ToolButtonData {
  final String title;
  final Widget icon;
  final VoidCallback? onTap;
  final bool comingSoon;
  final int captionMaxLines;
  final String? comingSoonLabel;

  const _ToolButtonData({
    required this.title,
    required this.icon,
    this.onTap,
    this.comingSoon = false,
    this.captionMaxLines = 1,
    this.comingSoonLabel,
  });

  bool get isEnabled => onTap != null && !comingSoon;

  Color get captionColor => comingSoon ? AC.greyText4 : AC.blackText6;
}

class _ChatToolButton extends StatelessWidget {
  const _ChatToolButton({required this.data});

  final _ToolButtonData data;

  @override
  Widget build(BuildContext context) {
    final badge = Positioned(
      left: SC.sw(-8),
      right: SC.sw(-8),
      bottom: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SC.sw(6),
            vertical: SC.sh(2),
          ),
          decoration: BoxDecoration(
            color: AC.redValidationText,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            data.comingSoonLabel ?? '',
            style: TextStyle(fontSize: SC.sf(8), color: Colors.white),
          ),
        ),
      ),
    );

    final button = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: SC.smin(52),
              height: SC.smin(52),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: data.icon,
              ),
            ),
            if (data.comingSoon) badge,
          ],
        ),
        SizedBox(height: SC.sh(6)),
        SizedBox(
          width: SC.sw(68),
          height: data.captionMaxLines > 1 ? SC.sh(32) : SC.sh(16),
          child: Text(
            data.title,
            textAlign: TextAlign.center,
            maxLines: data.captionMaxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
              fontSize: SC.sf(10),
              color: data.captionColor,
            ),
          ),
        ),
      ],
    );

    return TapEffect(onTap: data.isEnabled ? data.onTap : null, child: button);
  }
}

class _ChatInputGroup extends StatelessWidget {
  const _ChatInputGroup({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onPickImages,
    required this.isSendDisabled,
    required this.onToggleTools,
    required this.isToolPanelVisible,
    required this.hasPendingAttachments,
    required this.hintText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final ValueChanged<List<String>> onPickImages;
  final bool isSendDisabled;
  final VoidCallback onToggleTools;
  final bool isToolPanelVisible;
  final bool hasPendingAttachments;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AC.yellowChatInputGroup,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      padding: EdgeInsets.fromLTRB(SC.sw(12), SC.sh(12), SC.sw(12), SC.sh(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TapEffect(
            onTap: onToggleTools,
            child: Image.asset(
              'assets/icons/chat-tools-box.png',
              width: SC.smin(24),
            ),
          ),
          SizedBox(width: SC.sw(12)),
          Expanded(
            child: Container(
              height: SC.sh(46),
              padding: EdgeInsets.symmetric(horizontal: SC.sw(12)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hintText,
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  // _RoundedIconButton(
                  //   size: SC.smin(35),
                  //   iconSize: SC.smin(20),
                  //   backgroundColor: Colors.transparent,
                  //   iconColor: AC.neutralChatMeta,
                  //   icon: Icons.mic_none,
                  //   onPressed: () {},
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(width: SC.sw(12)),
          // _RoundedIconButton(
          //   size: SC.smin(46),
          //   iconSize: SC.smin(24),
          //   backgroundColor: AC.greenStrong1,
          //   iconColor: AC.greyBox1,
          //   icon: Icons.send_rounded,
          //   onPressed: () {
          //     final text = controller.text.trim();
          //     if (text.isNotEmpty) {
          //       onSend(text);
          //     }
          //   },
          // ),
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              final text = controller.text;
              final hasText = text.trim().isNotEmpty;
              final disabled = isSendDisabled;
              final shouldShow = hasText || hasPendingAttachments;
              final child = shouldShow
                  ? Opacity(
                      key: const ValueKey('paw-visible'),
                      opacity: disabled ? 0.3 : 1,
                      child: TapEffect(
                        onTap: disabled ? null : () => onSend(text),
                        child: Image.asset(
                          'assets/icons/chat-paw.png',
                          width: SC.smin(46),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('paw-hidden'));
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.horizontal,
                      axisAlignment: -1,
                      child: child,
                    ),
                  );
                },
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MessagesLoadingState extends StatelessWidget {
  const _MessagesLoadingState();

  @override
  Widget build(BuildContext context) {
    return TextLoadingIndicator(
      text: AppLocalizations.of(context)!.chatNewLoadingMessages,
    );
  }
}

class _MessagesErrorState extends StatelessWidget {
  const _MessagesErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SC.sw(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.chatNewLoadMessagesError(message),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SC.sf(14),
                color: AC.neutralLoadingText,
              ),
            ),
            SizedBox(height: SC.sh(12)),
            TapEffect(
              onTap: () {
                unawaited(onRetry());
              },
              child: Text(
                l10n.chatNewRetry,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: SC.sf(14),
                  color: AppColors.greenStrong1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatWelcomeState extends StatelessWidget {
  const _ChatWelcomeState({
    required this.onRefreshMessages,
    required this.onRetryWelcome,
    required this.welcomeContent,
    required this.isLoadingWelcome,
    required this.errorMessage,
    required this.onSuggestionTap,
    required this.l10n,
  });

  final Future<void> Function() onRefreshMessages;
  final VoidCallback onRetryWelcome;
  final ChatWelcomeContent? welcomeContent;
  final bool isLoadingWelcome;
  final String? errorMessage;
  final ValueChanged<String> onSuggestionTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (isLoadingWelcome) {
      body = SizedBox(
        height: SC.sh(200),
        child: Center(
          child: Text(
            l10n.chatNewSuggestionLoading,
            style: TextStyle(fontSize: SC.sf(14), color: AC.neutralLoadingText),
          ),
        ),
      );
    } else if (welcomeContent != null) {
      body = _ChatWelcomeCard(
        content: welcomeContent!,
        onSuggestionTap: onSuggestionTap,
      );
    } else {
      body = _ChatWelcomeError(
        message: errorMessage ?? l10n.chatNewSuggestionError,
        onRetry: onRetryWelcome,
        l10n: l10n,
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.symmetric(horizontal: SC.sw(16), vertical: SC.sh(24)),
      children: [
        body,
        SizedBox(height: SC.sh(12)),
        // TapEffect(
        //   onTap: () {
        //     unawaited(onRefreshMessages());
        //   },
        //   child: Text(
        //     'Tải lại tin nhắn',
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       fontWeight: FontWeight.w600,
        //       fontSize: SC.sf(13),
        //       color: AppColors.greenStrong1,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class _ChatWelcomeCard extends StatelessWidget {
  const _ChatWelcomeCard({
    required this.content,
    required this.onSuggestionTap,
  });

  final ChatWelcomeContent content;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        RectangleCachedNetworkImage(
          imageUrl: content.imageUrl,
          width: double.infinity,
          height: SC.sh(228),
          radius: 16,
          subject: ImageSubject.others,
        ),
        SizedBox(height: SC.sh(32)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: SC.smin(20),
              color: AppColors.greenStrong1,
            ),
            SizedBox(width: SC.sw(8)),
            Expanded(
              child: Text(
                content.title,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(16),
                  color: AC.deepPurpleOverlay70,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SC.sh(16)),
        if (content.suggestions.isNotEmpty)
          Wrap(
            spacing: SC.sw(12),
            runSpacing: SC.sh(12),
            children: content.suggestions
                .map(
                  (text) => _WelcomeSuggestionChip(
                    label: text,
                    onTap: () => onSuggestionTap(text),
                  ),
                )
                .toList(),
          ),
        // else
        // Text(
        //   'Hãy bắt đầu cuộc trò chuyện với bé yêu của mình!',
        //   style: TextStyle(
        //     fontSize: SC.sf(14),
        //     color: AC.neutralPrimaryText,
        //   ),
        // ),
      ],
    );
  }
}

class _WelcomeSuggestionChip extends StatelessWidget {
  const _WelcomeSuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(16),
          vertical: SC.sh(8),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greenStrong1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
            fontSize: SC.sf(14),
            color: AC.deepPurpleOverlay70,
          ),
        ),
      ),
    );
  }
}

class _ChatWelcomeError extends StatelessWidget {
  const _ChatWelcomeError({
    required this.message,
    required this.onRetry,
    required this.l10n,
  });

  final String message;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: SC.sf(15), color: AC.neutralLoadingText),
        ),
        SizedBox(height: SC.sh(12)),
        TapEffect(
          onTap: onRetry,
          child: Text(
            l10n.commonRetry,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: SC.sf(14),
              color: AppColors.greenStrong1,
            ),
          ),
        ),
      ],
    );
  }
}

class _PendingAttachmentPreview extends StatelessWidget {
  const _PendingAttachmentPreview({required this.urls, required this.onRemove});

  final List<String> urls;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final itemSize = SC.smin(64);
    return Wrap(
      spacing: SC.sw(8),
      runSpacing: SC.sh(8),
      children: List.generate(urls.length, (index) {
        final url = urls[index];
        return Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: RectangleCachedNetworkImage(
                imageUrl: url,
                width: itemSize,
                height: itemSize,
                radius: 12,
                subject: ImageSubject.others,
              ),
            ),
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  width: SC.smin(20),
                  height: SC.smin(20),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar({this.avatarUrl, this.size});

  final String? avatarUrl;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? SC.smin(24);
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleCachedNetworkImage(
        imageUrl: avatarUrl!,
        size: resolvedSize,
        subject: ImageSubject.pet,
      );
    }

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.greenStrong1.withAlpha((0.12 * 255).round()),
      ),
      child: Icon(
        Icons.pets,
        color: AC.greenStrong1,
        size: resolvedSize * 0.65,
      ),
    );
  }
}

class _TextBubble extends StatelessWidget {
  const _TextBubble({
    required this.text,
    required this.timeLabel,
    required this.maxWidth,
    required this.backgroundColor,
    required this.textColor,
    required this.timeColor,
    this.replyCount,
    this.showThreadButton = false,
    this.onSeeMore,
  });

  final String text;
  final String timeLabel;
  final double maxWidth;
  final Color backgroundColor;
  final Color textColor;
  final Color timeColor;
  final int? replyCount;
  final bool showThreadButton;
  final VoidCallback? onSeeMore;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.fromLTRB(SC.sw(16), SC.sh(16), SC.sw(16), SC.sh(8)),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: SC.sf(14),
                height: 1.4,
                color: textColor,
              ),
            ),
            SizedBox(height: SC.sh(6)),
            if (showThreadButton && onSeeMore != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TapEffect(
                    onTap: onSeeMore,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SC.sw(12),
                        vertical: SC.sh(6),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            replyCount != null
                                ? '${replyCount!} phản hồi'
                                : 'Xem thêm',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                              fontSize: SC.sf(12),
                              color: textColor,
                            ),
                          ),
                          SizedBox(width: SC.sw(6)),
                          Image.asset(
                            'assets/icons/ab-chevron-right.png',
                            width: SC.smin(12),
                            height: SC.smin(12),
                            color: textColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    timeLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(12),
                      color: timeColor,
                    ),
                  ),
                ],
              )
            else
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  timeLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: SC.sf(12),
                    color: timeColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductsBubble extends StatelessWidget {
  const _ProductsBubble({
    required this.products,
    required this.maxWidth,
    required this.backgroundColor,
    required this.timeLabel,
    required this.timeColor,
  });

  final List<Product> products;
  final double maxWidth;
  final Color backgroundColor;
  final String timeLabel;
  final Color timeColor;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.fromLTRB(SC.sw(16), SC.sh(16), SC.sw(16), SC.sh(8)),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductsCarousel(context),
            SizedBox(height: SC.sh(6)),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: SC.sf(12),
                  color: timeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsCarousel(BuildContext context) {
    final double itemWidth = SC.sw(120); // sản phẩm nhỏ, dễ xem
    final double itemHeight = SC.sh(170);

    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (_, __) => SizedBox(width: SC.sw(10)),
        itemBuilder: (context, index) {
          final product = products[index];

          return SizedBox(
            width: itemWidth,
            child: ProductItem(product: product),
          );
        },
      ),
    );
  }
}

class _ImagesBubble extends StatelessWidget {
  const _ImagesBubble({
    required this.imageUrls,
    required this.maxWidth,
    required this.backgroundColor,
    this.onTapImage,
    required this.timeLabel,
    required this.timeColor,
    this.caption,
    this.captionColor,
  });

  final List<String> imageUrls;
  final double maxWidth;
  final Color backgroundColor;
  final ValueChanged<String>? onTapImage;
  final String timeLabel;
  final Color timeColor;
  final String? caption;
  final Color? captionColor;

  @override
  Widget build(BuildContext context) {
    final displayedImages = imageUrls.take(9).toList();
    final remaining = imageUrls.length - displayedImages.length;
    final double spacingH = SC.smin(1);
    final double spacingV = SC.smin(1);
    final double imageEdgeInsetH = SC.smin(1);
    final double imageEdgeInsetV = SC.smin(1);
    final double desiredTextPadding = SC.smin(16);
    final double textInset = desiredTextPadding > imageEdgeInsetH
        ? desiredTextPadding - imageEdgeInsetH
        : 0;

    final bool hasCaption = caption != null;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          imageEdgeInsetH,
          imageEdgeInsetV,
          imageEdgeInsetH,
          caption == null ? imageEdgeInsetV : SC.smin(6),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasCaption)
              Stack(
                children: [
                  _PhotoMosaicLayout(
                    images: displayedImages,
                    spacingH: spacingH,
                    spacingV: spacingV,
                    maxWidth: maxWidth,
                    remainingCount: remaining,
                    onTapImage: onTapImage,
                    clipBottomCorners: true,
                  ),
                  Positioned(
                    right: SC.smin(8),
                    bottom: SC.smin(8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SC.smin(8),
                          vertical: SC.smin(2),
                        ),
                        child: Text(
                          timeLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: SC.sf(12),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else ...[
              _PhotoMosaicLayout(
                images: displayedImages,
                spacingH: spacingH,
                spacingV: spacingV,
                maxWidth: maxWidth,
                remainingCount: remaining,
                onTapImage: onTapImage,
                clipBottomCorners: false,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SC.smin(16),
                  left: textInset,
                  right: textInset,
                ),
                child: Text(
                  caption!,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                    fontSize: SC.sf(14),
                    color: captionColor ?? Colors.black,
                  ),
                ),
              ),
              SizedBox(height: spacingV),
              Padding(
                padding: EdgeInsets.only(left: textInset, right: textInset),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    timeLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(12),
                      color: timeColor,
                    ),
                  ),
                ),
              ),
            ],
            if (hasCaption) SizedBox(height: spacingV),
          ],
        ),
      ),
    );
  }
}

class _PhotoMosaicLayout extends StatelessWidget {
  const _PhotoMosaicLayout({
    required this.images,
    required this.spacingH,
    required this.spacingV,
    required this.maxWidth,
    required this.remainingCount,
    this.onTapImage,
    required this.clipBottomCorners,
  });

  final List<String> images;
  final double spacingH;
  final double spacingV;
  final double maxWidth;
  final int remainingCount;
  final ValueChanged<String>? onTapImage;
  final bool clipBottomCorners;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    final count = images.length;

    Widget layout;
    if (count == 1) {
      layout = _buildSingle(context, images.first);
    } else if (count == 2) {
      layout = _buildDoubleColumn(context, images);
    } else if (count == 3) {
      layout = _buildMosaicThree(
        context,
        left: images[0],
        topRight: images[1],
        bottomRight: images[2],
      );
    } else if (count == 4) {
      layout = _buildGrid(context, images, columns: 2);
    } else {
      layout = _buildGrid(context, images, columns: 3);
    }

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: clipBottomCorners ? const Radius.circular(16) : Radius.zero,
      bottomRight: clipBottomCorners ? const Radius.circular(16) : Radius.zero,
    );

    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: layout,
    );
  }

  Widget _buildSingle(BuildContext context, String url) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: _ImageTile(
        url: url,
        onTap: onTapImage,
        isLast: true,
        remainingCount: remainingCount,
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  Widget _buildDoubleColumn(BuildContext context, List<String> urls) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: _ImageTile(
            url: urls[0],
            onTap: onTapImage,
            borderRadius: BorderRadius.zero,
            isLast: false,
            remainingCount: remainingCount,
          ),
        ),
        SizedBox(height: spacingV),
        AspectRatio(
          aspectRatio: 4 / 3,
          child: _ImageTile(
            url: urls[1],
            onTap: onTapImage,
            isLast: true,
            remainingCount: remainingCount,
            borderRadius: BorderRadius.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildMosaicThree(
    BuildContext context, {
    required String left,
    required String topRight,
    required String bottomRight,
  }) {
    final double targetHeight = maxWidth * 0.7;
    return SizedBox(
      height: targetHeight,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(right: spacingH),
              child: _ImageTile(
                url: left,
                onTap: onTapImage,
                borderRadius: BorderRadius.zero,
                isLast: false,
                remainingCount: remainingCount,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: spacingV),
                    child: _ImageTile(
                      url: topRight,
                      onTap: onTapImage,
                      borderRadius: BorderRadius.zero,
                      isLast: false,
                      remainingCount: remainingCount,
                    ),
                  ),
                ),
                Expanded(
                  child: _ImageTile(
                    url: bottomRight,
                    onTap: onTapImage,
                    isLast: true,
                    remainingCount: remainingCount,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    List<String> urls, {
    required int columns,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double tileWidth = (width - spacingH * (columns - 1)) / columns;
        return Wrap(
          spacing: spacingH,
          runSpacing: spacingV,
          children: [
            for (int i = 0; i < urls.length; i++)
              SizedBox(
                width: tileWidth,
                height: tileWidth,
                child: _ImageTile(
                  url: urls[i],
                  onTap: onTapImage,
                  isLast: i == urls.length - 1,
                  remainingCount: remainingCount,
                  borderRadius: BorderRadius.zero,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.url,
    required this.onTap,
    required this.remainingCount,
    required this.isLast,
    required this.borderRadius,
  });

  final String url;
  final ValueChanged<String>? onTap;
  final int remainingCount;
  final bool isLast;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final showOverlay = isLast && remainingCount > 0;

    return GestureDetector(
      onTap: () => onTap?.call(url),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImageContent(),
            if (showOverlay)
              Container(
                color: Colors.black45,
                alignment: Alignment.center,
                child: Text(
                  '+$remainingCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: SC.sf(20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    if (url.startsWith('http')) {
      return RectangleCachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        radius: SC.smin(16),
        subject: ImageSubject.others,
      );
    }
    return Image.file(File(url), fit: BoxFit.cover);
  }
}
