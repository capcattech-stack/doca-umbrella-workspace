import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';

class CustomActionPopup extends StatelessWidget {
  final String title;
  final String message;

  /// Nút chính (màu xanh)
  final String primaryText;
  final VoidCallback onPrimaryTap;
  final Widget? primaryLeadingIcon;
  final Widget? primaryTrailingIcon;

  /// Nút phụ (màu xám)
  final String? secondaryText;
  final VoidCallback? onSecondaryTap;
  final Widget? secondaryLeadingIcon;
  final Widget? secondaryTrailingIcon;

  const CustomActionPopup({
    super.key,
    required this.title,
    required this.message,
    required this.primaryText,
    required this.onPrimaryTap,
    this.primaryLeadingIcon,
    this.primaryTrailingIcon,
    this.secondaryText,
    this.onSecondaryTap,
    this.secondaryLeadingIcon,
    this.secondaryTrailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.black.withOpacity(0.4),
        child: Container(
          width: SC.sw(320),
          padding: EdgeInsets.all(SC.sw(16)),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// --- Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(16),
                  height: 1.5,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: SC.sh(10)),

              /// --- Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: SC.sf(14),
                  height: 1.7,
                  color: AC.neutralPrimaryText,
                ),
              ),
              SizedBox(height: SC.sh(32)),

              /// --- Primary button
              ActionButton(
                text: primaryText,
                color: AppColors.greenStrong1,
                textColor: Colors.white,
                leadingIcon: primaryLeadingIcon,
                trailingIcon: primaryTrailingIcon,
                onTap: onPrimaryTap,
              ),

              if (secondaryText != null && onSecondaryTap != null) ...[
                SizedBox(height: SC.sh(16)),

                /// --- Secondary button
                ActionButton(
                  text: secondaryText!,
                  color: AC.greyBorder2,
                  textColor: AC.neutralPrimaryText,
                  leadingIcon: secondaryLeadingIcon,
                  trailingIcon: secondaryTrailingIcon,
                  onTap: onSecondaryTap!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
