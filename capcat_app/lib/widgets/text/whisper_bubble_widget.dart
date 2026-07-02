import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';

class WhisperBubbleWidget extends StatelessWidget {
  final String text;

  const WhisperBubbleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // --- Nội dung chính (bong bóng)
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SC.sw(16),
            vertical: SC.sh(8),
          ),
          constraints: BoxConstraints(
            minHeight: SC.sh(52),
            maxWidth: SC.sw(215),
          ),
          decoration: BoxDecoration(
            color: AC.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AC.blackText2.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            '“$text”',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              fontSize: SC.sf(14),
              height: 18 / 14,
              color: AC.purpleWhisperText,
            ),
          ),
        ),

        // --- Đuôi bong bóng nhỏ (2 hình tròn trắng)
        Positioned(
          left: SC.sw(-8),
          bottom: SC.sh(10),
          child: Container(
            width: SC.sw(16),
            height: SC.sh(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        Positioned(
          left: SC.sw(-16),
          bottom: SC.sh(4),
          child: Container(
            width: SC.sw(8),
            height: SC.sh(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
