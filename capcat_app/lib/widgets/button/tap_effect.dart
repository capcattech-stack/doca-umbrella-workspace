import 'package:flutter/material.dart';

enum TapEffectType { none, scale, opacity, both }

class TapEffect extends StatefulWidget {
  const TapEffect({
    super.key,
    required this.child,
    this.effect = TapEffectType.both,
    this.duration = const Duration(milliseconds: 50),
    this.scaleFactor = 0.95,
    this.opacityFactor = 0.7,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;
  final TapEffectType effect;
  final Duration duration;
  final double scaleFactor;
  final double opacityFactor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<TapEffect> createState() => _TapEffectState();
}

class _TapEffectState extends State<TapEffect> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (mounted) {
      setState(() => _pressed = value);
    }
  }

  Future<void> _handleTap() async {
    _setPressed(true);

    // Chờ hiệu ứng (nếu có) trước khi thực hiện onTap
    final shouldDelay =
        widget.effect != TapEffectType.none && widget.onTap != null;
    if (shouldDelay) {
      await Future.delayed(widget.duration);
    }

    _setPressed(false);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bool doScale =
        widget.effect == TapEffectType.scale ||
        widget.effect == TapEffectType.both;
    final bool doOpacity =
        widget.effect == TapEffectType.opacity ||
        widget.effect == TapEffectType.both;

    final double scale = (_pressed && doScale) ? widget.scaleFactor : 1.0;
    final double opacity = (_pressed && doOpacity) ? widget.opacityFactor : 1.0;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleTap,
      onTapDown: (_) => _setPressed(true),
      // onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onLongPress: widget.onLongPress,
      child: AnimatedOpacity(
        duration: widget.duration,
        opacity: opacity,
        child: AnimatedScale(
          duration: widget.duration,
          scale: scale,
          child: widget.child,
        ),
      ),
    );
  }
}
