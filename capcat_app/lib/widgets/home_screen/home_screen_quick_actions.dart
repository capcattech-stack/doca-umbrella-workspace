import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class HomeScreenQuickActions extends StatelessWidget {
  const HomeScreenQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.sh(80),
      width: SizeConfig.sw(327),
      // color: Colors.green.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _QuickActionItem(
            label: 'Pet ID',
            iconAsset: 'assets/images/pet-id.png',
          ),
          // SizedBox(width: 8),
          _QuickActionItem(
            label: 'Chia sẻ',
            iconAsset: 'assets/images/chia-se.png',
          ),
          // SizedBox(width: 8),
          _QuickActionItem(
            label: 'Kỷ niệm',
            iconAsset: 'assets/images/ky-niem.png',
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final String label;
  final String iconAsset;

  const _QuickActionItem({required this.label, required this.iconAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.sw(103.67),
      height: SizeConfig.sh(80),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: AC.greyTab1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Icon container (chiếm ~60%)
              SizedBox(
                height: constraints.maxHeight * 0.6,
                child: Center(
                  child: Container(
                    width: constraints.maxHeight * 0.5,
                    height: constraints.maxHeight * 0.5,
                    decoration: BoxDecoration(
                      color: AC.peachCardBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Center(
                      child: Image.asset(iconAsset, width: 24, height: 24),
                    ),
                  ),
                ),
              ),

              // Spacer hoặc sizedBox nhỏ nếu cần
              SizedBox(height: constraints.maxHeight * 0.05),

              // Label (chiếm phần còn lại)
              SizedBox(
                height: constraints.maxHeight * 0.3,
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
