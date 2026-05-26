import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';

class ActionButton extends StatelessWidget {
  final double? height;
  final bool isSmall;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? iconSize;
  final String text;
  final String? subText;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    this.height,
    this.isSmall = false,
    this.leadingIcon,
    this.trailingIcon,
    this.iconSize,
    required this.text,
    this.subText,
    this.color = AppColors.greenStrong1,
    this.textColor = AppColors.white,
    this.borderColor = Colors.transparent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      effect: TapEffectType.both, // bạn có thể đổi thành .scale hoặc .opacity
      onTap: onTap,
      child: Container(
        width: isSmall ? SizeConfig.sw(128) : double.infinity,
        height: height ?? SizeConfig.sh(56),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              SizedBox(
                width: SizeConfig.sw(iconSize ?? SC.smin(20)),
                height: SizeConfig.sw(iconSize ?? SC.smin(20)),
                child: Center(child: leadingIcon),
              ),
              SizedBox(width: SizeConfig.sw(6)),
            ],
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.sf(14),
                    color: textColor,
                  ),
                ),
                if (subText != null)
                  Text(
                    subText!,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.sf(12),
                      height: 22 / 12,
                      color: textColor,
                    ),
                  ),
              ],
            ),

            if (trailingIcon != null) ...[
              SizedBox(width: SizeConfig.sw(6)),
              SizedBox(
                width: SizeConfig.sw(iconSize ?? SC.smin(20)),
                height: SizeConfig.sw(iconSize ?? SC.smin(20)),
                child: Center(child: trailingIcon),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
