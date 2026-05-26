import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/transition_config.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MainBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static double itemSize = SC.smin(40);
  static double iconSize = SC.smin(24);
  static double hGap = SC.smin(12);

  static const List<List<String>> iconPaths = [
    ['assets/icons/home_stroke.png', 'assets/icons/home_fill.png'],
    // ['assets/icons/chat_stroke.png', 'assets/icons/chat_fill.png'],
    ['assets/icons/paw_stroke.png', 'assets/icons/paw_fill.png'],
    ['assets/icons/chat_stroke.png', 'assets/icons/chat_fill.png'],
    ['assets/icons/profile_stroke.png', 'assets/icons/profile_fill.png'],
  ];

  @override
  Widget build(BuildContext context) {
    return
    // SafeAreaTopOnly(
    //   child:
    Center(
      child: Container(
        // width: SC.phyBotBarWidth,
        width: (itemSize + hGap) * iconPaths.length + hGap,
        height: SC.phyBotBarHeight,
        padding: EdgeInsets.symmetric(horizontal: hGap),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(38),
              offset: Offset(0, SC.smin(6)),
              blurRadius: SC.smin(8),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(
                milliseconds: TransitionConfig.durationShort,
              ),
              curve: Curves.easeInOut,
              left: (itemSize + hGap) * currentIndex,
              top: SC.smin(12),
              child: Container(
                width: itemSize,
                height: itemSize,
                decoration: BoxDecoration(
                  color: AppColors.greenStrong1,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            // Dãy icon
            SizedBox(
              // height: SC.smin(SC.designBotNavBarHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(iconPaths.length, (index) {
                  final selected = index == currentIndex;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(index),
                    child: SizedBox(
                      width: itemSize,
                      height: itemSize,
                      child: Center(
                        child: AnimatedScale(
                          scale: selected ? 1.2 : 1.0,
                          duration: const Duration(
                            milliseconds: TransitionConfig.durationShort,
                          ),
                          curve: Curves.easeInOut,
                          child: Image.asset(
                            iconPaths[index][selected ? 1 : 0],
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
