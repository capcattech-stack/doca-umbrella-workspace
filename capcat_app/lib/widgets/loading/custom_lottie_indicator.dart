import 'package:flutter/material.dart';
import 'package:capcat_doca/gen/assets.gen.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:lottie/lottie.dart';

class CustomLottieIndicator extends StatelessWidget {
  const CustomLottieIndicator({
    super.key,
    this.lottieFile,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  final String? lottieFile;
  final double? height;
  final Color? color;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      lottieFile ?? Assets.lottie.pawLoading,
      height: height,
      fit: fit,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(['**'], value: color ?? AppColors.greenStrong1),
        ],
      ),
    );
  }
}
