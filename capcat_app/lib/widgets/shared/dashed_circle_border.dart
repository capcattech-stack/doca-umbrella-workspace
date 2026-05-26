import 'dart:math';
import 'package:flutter/material.dart';

class DashedCircleBorder extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpace;
  final int? dashCount;
  final Widget? child;

  const DashedCircleBorder({
    super.key,
    required this.size,
    required this.color,
    this.strokeWidth = 2,
    this.dashLength = 6,
    this.dashSpace = 4,
    this.dashCount,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DashedCirclePainter(
              color: color,
              strokeWidth: strokeWidth,
              dashLength: dashLength,
              dashSpace: dashSpace,
              dashCount: dashCount,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpace;
  final int? dashCount;

  _DashedCirclePainter({
    required this.color,
    this.strokeWidth = 2,
    this.dashLength = 6,
    this.dashSpace = 4,
    this.dashCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final radius = (min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    final totalAngle = 2 * pi;

    double sweepAngle;
    double spaceAngle;

    if (dashCount != null && dashCount! > 0) {
      sweepAngle = totalAngle / (dashCount! * 2);
      spaceAngle = sweepAngle;
    } else {
      sweepAngle = dashLength / radius;
      spaceAngle = dashSpace / radius;
    }

    for (
      double angle = 0;
      angle < totalAngle;
      angle += sweepAngle + spaceAngle
    ) {
      canvas.drawArc(rect, angle, sweepAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        dashLength != oldDelegate.dashLength ||
        dashSpace != oldDelegate.dashSpace ||
        dashCount != oldDelegate.dashCount;
  }
}
