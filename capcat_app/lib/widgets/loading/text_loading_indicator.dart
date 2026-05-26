import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';

class TextLoadingIndicator extends StatelessWidget {
  const TextLoadingIndicator({
    super.key,
    this.text = 'Đang tải...',
    this.color = AC.neutralLoadingText,
    this.fontSize,
  });

  final String text;
  final Color color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? SC.sf(14),
          color: color,
        ),
      ),
    );
  }
}
