import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';

class SplashBaseSheet extends StatelessWidget {
  final double height;
  final Widget childWidget;
  final String topIconAsset;

  const SplashBaseSheet({
    super.key,
    required this.height,
    required this.childWidget,
    this.topIconAsset = 'assets/icons/profile.png',
  });

  @override
  Widget build(BuildContext context) {
    final sheetWidth = SC.physicScreenWidth;
    final bulletSize = SC.smin(80);
    final bulletInnerSize = SC.smin(64);
    final borderRadius = Radius.circular(26);

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            RepaintBoundary(
              child: Container(
                width: double.infinity,
                height: height,
                decoration: BoxDecoration(
                  color: AC.white,
                  borderRadius: BorderRadius.only(
                    topLeft: borderRadius,
                    topRight: borderRadius,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: bulletSize / 2),
                    Expanded(child: childWidget),
                  ],
                ),
              ),
            ),

            //--Outer Circle
            Positioned(
              top: -bulletSize / 2,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: bulletSize,
                  height: bulletSize,
                  decoration: const BoxDecoration(
                    color: AC.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            //--Inner Circle
            Positioned(
              top: -bulletSize / 2,
              left: (sheetWidth - bulletSize) / 2,
              child: RepaintBoundary(
                child: Container(
                  width: bulletSize,
                  height: bulletSize,
                  alignment: Alignment.center,
                  child: Container(
                    width: bulletInnerSize,
                    height: bulletInnerSize,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                        color: AppColors.greenStrong1,
                      ),
                      borderRadius: BorderRadius.circular(bulletInnerSize),
                    ),
                    child: Center(
                      child: Image.asset(
                        topIconAsset,
                        width: SC.smin(36),
                        height: SC.smin(36),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
