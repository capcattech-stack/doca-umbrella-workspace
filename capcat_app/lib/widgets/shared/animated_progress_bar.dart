import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/transition_config.dart';

class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final hp = SC.sw(24);
    final progress = currentStep / totalSteps;

    return Container(
      width: double.infinity,
      height: 6,
      margin: EdgeInsets.symmetric(horizontal: hp),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background with rounded edges
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(height: SC.sh(3), color: AC.greyLine2),
          ),

          // Foreground progress with rounded edges
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: TransitionConfig.durationShort,
              ),
              curve: Curves.easeInOut,
              height: SC.sh(6),
              width: (SC.physicScreenWidth - hp * 2) * progress,
              color: AC.greenLine1,
            ),
          ),
        ],
      ),
    );
  }
}
