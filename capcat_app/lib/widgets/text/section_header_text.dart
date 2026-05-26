import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class SectionHeaderText extends StatelessWidget {
  const SectionHeaderText(
    this.headerText, {
    super.key,
    this.isOptional = false,
  });
  final String headerText;
  final bool isOptional;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          headerText,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(14),
            height: 20 / 14,
            letterSpacing: 0.2,
            color: AC.blackText4,
          ),
        ),
        if (!isOptional) ...[
          SizedBox(width: SC.sw(8)),
          Text(
            '*',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              fontSize: SC.sf(12),
              height: 20 / 12,
              color: AC.redValidationText,
            ),
          ),
        ],
      ],
    );
  }
}
