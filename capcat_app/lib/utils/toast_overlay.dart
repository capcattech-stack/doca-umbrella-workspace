import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';

class ToastOverlay {
  static OverlayEntry? _currentToast;
  static Timer? _timer;

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    // Remove old toast if exists
    _removeCurrent();

    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (ctx) =>
          _ToastWidget(message: message, onFinished: _removeCurrentImmediately),
    );

    overlay.insert(entry);
    _currentToast = entry;

    // Start timer to hide
    _timer = Timer(duration, () {
      hide();
    });
  }

  /// Called to start hide animation
  static void hide() {
    _ToastWidgetState.currentState?.startReverse();
  }

  /// Internal remove after animation ends
  static void _removeCurrentImmediately() {
    _timer?.cancel();
    _timer = null;

    _currentToast?.remove();
    _currentToast = null;
  }

  /// Remove without animation when replaced
  static void _removeCurrent() {
    _timer?.cancel();
    _timer = null;

    _currentToast?.remove();
    _currentToast = null;
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback onFinished;

  const _ToastWidget({required this.message, required this.onFinished});

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  static _ToastWidgetState? currentState;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    currentState = this;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      reverseDuration: const Duration(milliseconds: 130),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _offset = Tween<Offset>(begin: const Offset(0, 0.20), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.fastOutSlowIn,
            reverseCurve: Curves.easeIn,
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    if (currentState == this) currentState = null;
    _controller.dispose();
    super.dispose();
  }

  /// Called externally
  void startReverse() async {
    if (!_controller.isAnimating && mounted) {
      await _controller.reverse();
      if (mounted) widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SC.sw(24)),
          child: GestureDetector(
            onTap: startReverse,
            child: SlideTransition(
              position: _offset,
              child: FadeTransition(
                opacity: _fade,
                child: Material(
                  elevation: 6,
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SC.sw(16),
                      vertical: SC.sh(14),
                    ),
                    decoration: BoxDecoration(
                      color: AC.charcoalToastBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: SC.sf(14),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25,
                        height: 20 / 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef TO = ToastOverlay;
