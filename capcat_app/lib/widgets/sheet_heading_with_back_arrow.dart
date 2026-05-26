import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class SheetHeadingWithBackArrow extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const SheetHeadingWithBackArrow({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack ?? () => Navigator.of(context).maybePop(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(right: SizeConfig.sw(8)),
            child: Icon(
              Icons.arrow_back,
              size: SizeConfig.sf(24),
              color: AppColors.blackText1,
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
              fontSize: SizeConfig.sf(24),
              color: AppColors.blackText1,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
