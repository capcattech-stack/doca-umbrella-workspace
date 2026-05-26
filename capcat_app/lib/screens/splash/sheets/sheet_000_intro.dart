import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/splash_base_sheet.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class IntroSheet extends StatelessWidget {
  final void Function(SplashActionSheet nextSheet) changeSheet;
  const IntroSheet({super.key, required this.changeSheet});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sheetContent = SizedBox(
      width: SizeConfig.sw(327),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.sh(24)),
          _buildProgressBar(),
          SizedBox(height: SizeConfig.sh(24)),
          _buildTitleAndDescription(l10n),
          SizedBox(height: SizeConfig.sh(16)),
          ActionButton(
            text: l10n.introStart,
            color: AppColors.greenStrong1,
            onTap: () {
              changeSheet(SplashActionSheet.signInUp);
            },
          ),
        ],
      ),
    );

    return SplashBaseSheet(
      height: SizeConfig.sh(432),
      topIconAsset: 'assets/images/icon_edit_splash.png',
      childWidget: sheetContent,
    );
  }

  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBarSegment(59.67, 3, AC.slateIntroStroke),
        SizedBox(width: SizeConfig.sw(6)),
        _buildBarSegment(56.67, 6, AC.peachAddIconBg),
        SizedBox(width: SizeConfig.sw(6)),
        _buildBarSegment(59.67, 3, AC.slateIntroStroke),
      ],
    );
  }

  Widget _buildBarSegment(double width, double height, Color color) {
    return Container(
      width: SizeConfig.sw(width),
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildTitleAndDescription(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.introTitle,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.sf(24),
            color: AC.blackText5,
            height: 34 / 24,
          ),
          textAlign: TextAlign.center,
        ),
          SizedBox(height: SizeConfig.sh(10)),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: SizeConfig.sf(16) * 1.5 * 8),
          child: Text(
            l10n.introDescription,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.sf(16),
              color: AC.greyText5,
              height: 24 / 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // Widget _buildButton() {
  //   return Container(
  //     width: SizeConfig.scaleWidth(375),
  //     padding: EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(24)),
  //     child: ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: AC.peachAddIconBg,
  //         padding: EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(17)),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(999),
  //         ),
  //       ),
  //       onPressed: () {
  //         changeSheet(SplashActionSheet.signInUp);
  //       },
  //       child: Text(
  //         'Bắt đầu ngay',
  //         style: TextStyle(
  //           fontFamily: 'Quicksand',
  //           fontWeight: FontWeight.w500,
  //           fontSize: SizeConfig.scaleFont(14),
  //           color: Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
