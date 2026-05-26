import 'package:flutter/material.dart';

class ChatPresentationController {
  ChatPresentationController({
    required TickerProvider vsync,
    Duration fadeDuration = const Duration(milliseconds: 250),
  }) {
    _fadeController = AnimationController(vsync: vsync, duration: fadeDuration);
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  late final AnimationController _fadeController;
  late final Animation<double> _fade;

  Animation<double> get fade => _fade;

  bool _hasShownInitialContent = false;
  bool get hasShownInitialContent => _hasShownInitialContent;

  bool _hasPerformedInitialScroll = false;
  bool _initialScrollScheduled = false;

  bool _showToolPanel = false;
  bool get showToolPanel => _showToolPanel;

  bool resetRevealState() {
    final hadState =
        _hasShownInitialContent || _hasPerformedInitialScroll || _initialScrollScheduled;
    _fadeController.reset();
    _hasShownInitialContent = false;
    _hasPerformedInitialScroll = false;
    _initialScrollScheduled = false;
    return hadState;
  }

  bool revealChatContent() {
    if (_hasShownInitialContent) return false;
    _hasShownInitialContent = true;
    _fadeController.forward();
    return true;
  }

  void scheduleInitialScrollAndReveal({
    required ScrollController scrollController,
    required bool Function() isMounted,
    required VoidCallback requestRebuild,
  }) {
    if (_hasShownInitialContent || _initialScrollScheduled) return;
    _initialScrollScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isMounted() || _hasShownInitialContent) return;
      _jumpToLatestOnce(scrollController: scrollController, isMounted: isMounted);
      if (revealChatContent()) {
        requestRebuild();
      }
    });
  }

  bool toggleToolPanel({
    required bool isKeyboardVisible,
    required VoidCallback unfocusKeyboard,
  }) {
    final shouldShow = !_showToolPanel;
    if (shouldShow && isKeyboardVisible) {
      unfocusKeyboard();
    }
    _showToolPanel = shouldShow;
    return shouldShow;
  }

  bool hideToolPanel() {
    if (!_showToolPanel) return false;
    _showToolPanel = false;
    return true;
  }

  void _jumpToLatestOnce({
    required ScrollController scrollController,
    required bool Function() isMounted,
  }) {
    if (_hasPerformedInitialScroll) return;
    _hasPerformedInitialScroll = true;
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
    Future.delayed(const Duration(milliseconds: 80), () {
      if (!isMounted() || !scrollController.hasClients) return;
      final remaining =
          scrollController.position.maxScrollExtent - scrollController.position.pixels;
      if (remaining > 1) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  void dispose() {
    _fadeController.dispose();
  }
}
