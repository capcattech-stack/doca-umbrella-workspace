import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';

class AddPetIntroCard extends StatelessWidget {
  const AddPetIntroCard({super.key, required this.onTap, this.height});

  final VoidCallback onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: onTap,
      child: CustomPaint(
        foregroundPainter: _DashedRoundedRectBorderPainter(
          color: AC.blackText6,
          strokeWidth: 1.5,
          dashWidth: SC.sw(14),
          dashGap: SC.sw(10),
          radius: SC.smin(24),
        ),
        child: Container(
          width: double.infinity,
          height: height ?? SC.sh(200),
          padding: EdgeInsets.symmetric(
            horizontal: SC.sw(8),
            vertical: SC.sh(24),
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AC.white, AC.beigeAddCardBg],
              stops: [0.311, 1.0],
            ),
            borderRadius: BorderRadius.circular(SC.smin(24)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/my-pets-add-art.png',
                width: SC.sw(64),
              ),
              SizedBox(height: SC.sh(16)),
              Text(
                '+ Thêm hồ sơ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(14),
                  height: 24 / 14,
                  letterSpacing: 0.4,
                  color: AC.charcoalAddPetText,
                ),
              ),
              SizedBox(height: SC.sh(4)),
              Text(
                'Đừng để các Boss chờ lâu, đăng ký cho bạn ấy ngay.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w400,
                  fontSize: SC.sf(12),
                  height: 20 / 12,
                  letterSpacing: -0.23,
                  color: AC.charcoalAddPetText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRoundedRectBorderPainter extends CustomPainter {
  const _DashedRoundedRectBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = (distance + dashWidth < metric.length)
            ? distance + dashWidth
            : metric.length;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap ||
        oldDelegate.radius != radius;
  }
}
