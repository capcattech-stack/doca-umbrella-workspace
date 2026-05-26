import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/text/section_header_text.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';

class PetForm4thSheet extends ConsumerWidget {
  const PetForm4thSheet({super.key, this.leftButton, this.rightButton});
  final Widget? leftButton;
  final Widget? rightButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double hp = SC.sw(24);
    final double smallVp = SC.sh(8);
    final double mediumVp = SC.sh(16);
    final double largeVp = SC.sh(24);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        hp,
        0,
        hp,
        MQ.bottomPadding(context) + mediumVp,
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: largeVp),
                SectionHeaderText(AppLocalizations.of(context)!.petFormAddCollarTitle),
                SizedBox(height: smallVp),
                const _AddNeckBandButton(),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [leftButton ?? SizedBox(), rightButton ?? SizedBox()],
          ),
        ],
      ),
    );
  }
}

class _AddNeckBandButton extends StatelessWidget {
  const _AddNeckBandButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // để thấy ripple
      child: TapEffect(
        onTap: () {
          ToastOverlay.show(
            context,
            AppLocalizations.of(context)!.petFormFeatureComingSoon,
          );
        },
        child: Container(
          width: double.infinity,
          height: SC.sh(46),
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(168, 216, 185, 0.1),
            border: Border.all(color: AC.greenChipBorder, width: 1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Image.asset('assets/icons/scan.png'),
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)!.petFormAddCollarScan,
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 20 / 14,
                  color: AC.blackText3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
