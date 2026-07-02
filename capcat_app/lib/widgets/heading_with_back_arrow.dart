import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';

class HeadingWithBackArrow extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const HeadingWithBackArrow({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack ?? () => Navigator.of(context).maybePop(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(right: SizeConfig.sw(8)),
            child: Image.asset(
              'assets/icons/splash-back.png',
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
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
