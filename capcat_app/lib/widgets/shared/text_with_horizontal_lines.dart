import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';

class TextWithHorizontalLines extends StatelessWidget {
  const TextWithHorizontalLines({
    super.key,
    required this.text,
    this.totalWidth = 327,
    this.lineLength = 131,
    this.lineColor = AC.greyLine2,
    this.textColor = AC.greyText5,
    this.gap = 16.0,
  });

  final String text;
  final double totalWidth;
  final double lineLength;
  final Color lineColor;
  final Color textColor;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalWidth,
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left Line
          SizedBox(
            width: lineLength,
            child: Divider(color: lineColor, thickness: 1, height: 1),
          ),
          SizedBox(width: gap),

          // Text
          SizedBox(
            width: 33,
            height: 22,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    // fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 20 / 14,
                    color: AC.greyText5,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: gap),
          // Right Line
          SizedBox(
            width: lineLength,
            child: Divider(color: lineColor, thickness: 1, height: 1),
          ),
        ],
      ),
    );
  }
}
