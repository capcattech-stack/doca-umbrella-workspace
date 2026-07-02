import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/models/conversation.dart';
import 'package:capcat_doca/models/message.dart';
import 'package:capcat_doca/models/product.dart';
import 'package:capcat_doca/providers/conversation_messages_provider.dart';
import 'package:capcat_doca/providers/socket_provider.dart';
import 'package:capcat_doca/screens/main/chat/shared/chat_screen_contract.dart';
import 'package:capcat_doca/screens/main/chat/shared/controller/chat_presentation_controller.dart';
import 'package:capcat_doca/screens/main/chat/shared/models/chat_view_contracts.dart';
import 'package:capcat_doca/screens/main/chat/shared/message_actions/chat_message_actions_resolver.dart';
import 'package:capcat_doca/screens/main/chat/shared/message_actions/chat_message_actions_sheet.dart';
import 'package:capcat_doca/screens/main/chat/shared/sections/chat_message_states_section.dart';
import 'package:capcat_doca/screens/main/chat/shared/sections/chat_screen_shell.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_attachment_preview.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_avatar.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_input_group.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_rich_bubbles.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_text_bubble.dart';
import 'package:capcat_doca/screens/main/chat/shared/widgets/chat_tool_panel.dart';
import 'package:capcat_doca/services/chat_attachment_service.dart';
import 'package:capcat_doca/services/image_picker_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/fade_in_wrapper.dart';
import 'package:capcat_doca/widgets/viewer/full_screen_gallery_viewer.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatThreadScreen extends ConsumerStatefulWidget {
  const ChatThreadScreen({
    super.key,
    required this.conversation,
    required this.rootMessageId,
  });

  final Conversation conversation;
  final String rootMessageId;

  @override
  ConsumerState<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends ConsumerState<ChatThreadScreen>
    with TickerProviderStateMixin {
  io.Socket? _socket;
  ProviderSubscription<AsyncValue<io.Socket?>>? _socketSubscription;
  late final StreamSubscription<bool> _keyboardSubscription;
  final DateFormat _timeFormatter = DateFormat('HH:mm');

  final List<Message> _pendingMessages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _pendingAttachmentUrls = [];
  late final ChatPresentationController _presentationController;
  bool _isUploadingImage = false;
  final GlobalKey _toolPanelKey = GlobalKey();
  final GlobalKey _inputGroupKey = GlobalKey();
  bool _isKeyboardVisible = false;
  String? _headerTitle;
  int? _headerReplyCount;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _presentationController = ChatPresentationController(vsync: this);

    _keyboardSubscription = KeyboardVisibilityController().onChange.listen((
      bool visible,
    ) {
      _isKeyboardVisible = visible;
      if (visible) {
        if (_presentationController.showToolPanel) {
          _hideToolPanel();
        }
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
  }

  ChatScreenContract get _contract =>
      ChatScreenContracts.thread(rootMessageId: widget.rootMessageId);

  ConversationMessagesArgs get _messageArgs => (
    conversationId: widget.conversation.id,
    parentId: _contract.parentId,
    currentAccountId: widget.conversation.userAccountId,
  );

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
      onTapNumerology: () {},
      onTapConstellation: () {},
      onTapCreateContent: () {},
    );
  }

  List<Message> _mergeMessages(List<Message> remoteMessages) {
    if (_pendingMessages.isEmpty) return remoteMessages;
    return [...remoteMessages, ..._pendingMessages];
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
    if (shouldShow) {
      _ensureLatestMessagesVisible(150);
    }
  }

  void _hideToolPanel() {
    if (!_presentationController.hideToolPanel()) return;
    setState(() {});
  }

  void _ensureLatestMessagesVisible(int durationMs) {
    Future.delayed(Duration(milliseconds: durationMs), () {
      if (!mounted) return;
      _scrollToBottom(300);
    });
  }

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
    final picked = await ImagePickerService.pickImages(context);
    final paths = picked?.paths ?? [];
    if (!mounted) return;
    if (paths.isNotEmpty) {
      _handleImageSelection(paths);
    }
    _hideToolPanel();
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
    setState(() {
      _pendingMessages.add(message);
      _headerReplyCount = (_headerReplyCount ?? 0) + 1;
    });
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

    final messagePayload = <String, dynamic>{
      'content': content,
      'reply_to': widget.rootMessageId,
    };
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

    setState(() {
      _pendingMessages.add(
        Message(text: content, isSentByUser: true, imageUrls: previewUrls),
      );
      _headerReplyCount = (_headerReplyCount ?? 0) + 1;
    });
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
    final double maxBubbleWidth = MediaQuery.of(context).size.width * 0.7;
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
        if (!isMe)
          Padding(
            padding: EdgeInsets.only(right: SC.sw(8)),
            child: showAvatar
                ? ChatAvatar(avatarUrl: avatarUrl)
                : SizedBox(width: SC.sw(32)),
          ),
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
    final messagesAsync = ref.watch(conversationMessagesProvider(_messageArgs));
    String headerTitle = _headerTitle ?? 'Phản hồi';
    int? headerReplyCount = _headerReplyCount;
    final composerData = _buildComposerViewData(l10n);
    final composerActions = _buildComposerActions();
    final toolPanelActions = _buildToolPanelActions();

    final messagesContent = messagesAsync.when(
      data: (remoteMessages) {
        if (_headerTitle == null) {
          final title = _findRichContentTitle(remoteMessages);
          if (title != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() => _headerTitle = title);
              }
            });
            headerTitle = title;
          }
        }
        if (_headerReplyCount == null && remoteMessages.isNotEmpty) {
          final count = remoteMessages.first.replyCount;
          if (count != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() => _headerReplyCount = count);
              }
            });
            headerReplyCount = count;
          }
        }
        _scheduleInitialScrollAndReveal();
        final mergedMessages = _mergeMessages(remoteMessages);
        if (mergedMessages.isEmpty) {
          return const SizedBox.shrink();
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
                            l10n.chatNewUploadingImageShort,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                headerTitle,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: SC.sf(16),
                  height: 22 / 16,
                  color: AC.blackText5,
                ),
              ),
              if (headerReplyCount != null)
                Text(
                  '$headerReplyCount phản hồi',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                    fontSize: SC.sf(13),
                    height: 1.2,
                    color: AC.neutralChatSubtext,
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    return ChatScreenShell(
      hideAssistantFab: _contract.hidesAssistantFab,
      onGlobalPointerDown: _handleGlobalPointerDown,
      contentFade: _presentationController.fade,
      headerTitle: headerTitle,
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
        showAdvancedTools: false,
      ),
      bottomInsetHeight: SC.sh(MQ.bottomPadding(context)),
      bottomBarColorWhenToolPanelShown: AC.yellowToolPanel,
      bottomBarColorWhenToolPanelHidden: AC.yellowChatInputGroup,
      showInitialLoadingOverlay:
          !_presentationController.hasShownInitialContent,
      initialLoadingText: l10n.chatNewLoadingConversation,
    );
  }

  String? _findRichContentTitle(List<Message> messages) {
    if (messages.isEmpty) return null;
    final rich = messages.first.richContent;
    if (rich is Map<String, dynamic>) {
      final title = rich['title'];
      if (title is String && title.trim().isNotEmpty) {
        return title.trim();
      }
    }
    return null;
  }

  @override
  void dispose() {
    _socketSubscription?.close();
    _keyboardSubscription.cancel();
    _scrollController.removeListener(_clampScrollBounds);
    _controller.dispose();
    _scrollController.dispose();
    _presentationController.dispose();
    _detachSocket();
    super.dispose();
  }
}
