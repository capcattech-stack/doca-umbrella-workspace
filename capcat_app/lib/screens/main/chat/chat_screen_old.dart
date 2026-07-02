import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:capcat_doca/services/socket_service.dart';
import 'package:capcat_doca/services/image_picker_service.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/widgets/product_item.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../models/message.dart';
import '../../../widgets/fade_in_wrapper.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../../../data/sample_products.dart';
import 'package:capcat_doca/widgets/image/rectangle_cached_network_image.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';

class ChatScreenOld extends StatefulWidget {
  const ChatScreenOld({super.key});

  @override
  State<ChatScreenOld> createState() => _ChatScreenOldState();
}

class _ChatScreenOldState extends State<ChatScreenOld> {
  io.Socket? _socket;
  final Random _random = Random();
  late final StreamSubscription<bool> _keyboardSubscription;
  // final FocusNode _focusNode = FocusNode();

  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // late final StreamSubscription<bool> _keyboardSubscription;

  List<String> _botResponses = const [];
  List<String> _sampleMessages = const [];

  @override
  void initState() {
    super.initState();

    _connectSocket();

    // Tạo hội thoại mẫu
    //_initializeDefaultConversation();

    // Theo dõi sự kiện keyboard
    _keyboardSubscription = KeyboardVisibilityController().onChange.listen((
      bool visible,
    ) {
      if (visible) {
        _scrollToBottomRepeatedly(500, 100);
      }
    });

    // _focusNode.addListener(() {
    //   if (_focusNode.hasFocus) {
    //     //_scrollToBottomRepeatedly(500, 100);
    //     _scrollToBottomRepeatedly(500, 50);
    //     Future.delayed(const Duration(milliseconds: 500), () {
    //       _scrollToBottom(500);
    //     });
    //   }
    // });
  }

  void _connectSocket() {
    final socket = SocketService.instance.connect();
    _socket = socket;
    socket.off('message', _handleSocketMessage);
    socket.on('message', _handleSocketMessage);
  }

  void _handleSocketMessage(dynamic data) {
    if (!mounted) return;
    setState(() => _messages.add(Message(text: '$data', isSentByUser: false)));
  }

  void _sendMessage(String text) {
    final socket = _socket ?? SocketService.instance.connect();
    if (!socket.connected) {
      socket.connect();
    }
    socket.emit('message', text);
    setState(() => _messages.add(Message(text: text, isSentByUser: true)));
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(500);
    });
  }

  List<String> _generateSampleImages() {
    final count = _random.nextInt(7) + 4;
    return List.generate(
      count,
      (index) =>
          'https://picsum.photos/seed/image${_random.nextInt(1000)}/200/200',
    );
  }

  void _showImageFullscreen(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: AppColors.greenStrong1.withAlpha((0.1 * 255).toInt()),
          child: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 4,
              child: RectangleCachedNetworkImage(
                imageUrl: imageUrl,
                width: SC.sw(300),
                height: SC.sw(300),
                fit: BoxFit.contain,
                radius: 0,
                subject: ImageSubject.others,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToBottom(int milliseconds) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: milliseconds),
          curve: Curves.easeInOut,
        );
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

  void _scrollToBottomRepeatedly(int duration, int interval) {
    int count = 0;
    int times = (duration / interval).toInt();
    final intervalDuration = Duration(milliseconds: interval);

    Timer.periodic(intervalDuration, (timer) {
      _scrollToBottomLinear(interval);
      count++;
      if (count >= times) timer.cancel();
    });
  }

  void _sendMessageFake() {
    final l10n = AppLocalizations.of(context)!;
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isSentByUser: true));
    });

    _controller.clear();
    _scrollToBottom(500);

    if (text.toLowerCase() == 'items') {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add(
            Message(text: l10n.chatOldProductsIntro, isSentByUser: false),
          );
          _messages.add(
            Message(
              text: '__PRODUCTS__',
              isSentByUser: false,
              products: sampleProducts,
            ),
          );
        });
        _scrollToBottom(500);
      });
      return;
    } else if (text.toLowerCase() == 'pics') {
      Future.delayed(const Duration(seconds: 1), () {
        final images = _generateSampleImages();
        setState(() {
          _messages.add(
            Message(text: l10n.chatOldImagesIntro, isSentByUser: false),
          );
          _messages.add(
            Message(text: '__IMAGES__', isSentByUser: false, imageUrls: images),
          );
        });
        _scrollToBottom(500);
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        final response = _botResponses[_random.nextInt(_botResponses.length)];
        setState(() {
          _messages.add(Message(text: response, isSentByUser: false));
        });
        _scrollToBottom(500);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CustomScaffold(
      resizeToAvoidBottomInset: true,

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                Widget messageWidget;

                if (msg.text == '__PRODUCTS__' && msg.products != null) {
                  // final items = msg.productItems!.take(10).toList();
                  // final screenWidth = MediaQuery.of(context).size.width;
                  // final itemWidth = (screenWidth - 48) / 2.5;

                  messageWidget = Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: msg.products!.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final product = msg.products![i];
                          return ProductItem(product: product);
                        },
                      ),
                    ),
                  );
                } else if (msg.text == '__IMAGES__' && msg.imageUrls != null) {
                  final displayedImages = msg.imageUrls!.take(9).toList();
                  final screenWidth = MediaQuery.of(context).size.width;
                  final imageWidth = (screenWidth - 48) / 3;

                  messageWidget = Align(
                    alignment: msg.isSentByUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth * 0.8;
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 0,
                              maxWidth: maxWidth,
                              minHeight: imageWidth,
                              maxHeight: imageWidth,
                            ),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: displayedImages.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                final url = displayedImages[i];
                                return GestureDetector(
                                  onTap: () => _showImageFullscreen(url),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: url.startsWith('http')
                                        ? RectangleCachedNetworkImage(
                                            imageUrl: url,
                                            width: imageWidth,
                                            height: imageWidth,
                                            radius: 8,
                                            subject: ImageSubject.others,
                                          )
                                        : Image.file(
                                            File(url),
                                            width: imageWidth,
                                            height: imageWidth,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  messageWidget = Align(
                    alignment: msg.isSentByUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: msg.isSentByUser
                            ? AppColors.greenStrong1
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(msg.text),
                    ),
                  );
                }
                return FadeInWrapper(child: messageWidget);
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: AC.greenStrong1),
                  onPressed: () async {
                    final picked = await ImagePickerService.pickImages(context);
                    final imagePaths = picked?.paths ?? [];
                    if (imagePaths.isEmpty) return;
                    setState(() {
                      _messages.add(
                        Message(
                          text: '__IMAGES__',
                          isSentByUser: true,
                          imageUrls: imagePaths,
                        ),
                      );
                    });
                    _scrollToBottom(500);
                  },
                ),
                Expanded(
                  // child: GestureDetector(
                  //   behavior: HitTestBehavior.translucent,
                  //   onTap: () {
                  //     WidgetsBinding.instance.addPostFrameCallback((_) {
                  //       _scrollToBottomRepeatedly(500, 100);
                  //     });
                  //   },
                  child: TextField(
                    controller: _controller,
                    // focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: l10n.chatOldInputHint,
                      fillColor: AppColors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  // ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.greenStrong1,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    //onPressed: _sendMessageFake,
                    onPressed: () {
                      _sendMessage(_controller.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    // _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    _socket?.off('message', _handleSocketMessage);
    _socket?.disconnect();
    SocketService.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _botResponses = [
      l10n.chatOldBotResponse1,
      l10n.chatOldBotResponse2,
      l10n.chatOldBotResponse3,
      l10n.chatOldBotResponse4,
      l10n.chatOldBotResponse5,
      l10n.chatOldBotResponse6,
      l10n.chatOldBotResponse7,
      l10n.chatOldBotResponse8,
      l10n.chatOldBotResponse9,
      l10n.chatOldBotResponse10,
      l10n.chatOldBotResponse11,
      l10n.chatOldBotResponse12,
    ];

    _sampleMessages = [
      l10n.chatOldSampleMessage1,
      l10n.chatOldSampleMessage2,
      l10n.chatOldSampleMessage3,
      l10n.chatOldSampleMessage4,
      l10n.chatOldSampleMessage5,
    ];
  }

  void _initializeDefaultConversation() {
    for (int i = 0; i < 5 && i < _sampleMessages.length; i++) {
      _messages.add(Message(text: _sampleMessages[i], isSentByUser: true));
      _messages.add(
        Message(
          text: _botResponses[_random.nextInt(_botResponses.length)],
          isSentByUser: false,
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(500);
    });
  }
}
