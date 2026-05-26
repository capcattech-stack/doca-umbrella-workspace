import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/otp_type.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/providers/social_register_data_provider.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/phone_number_util.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/heading_with_back_arrow.dart';
import 'package:flutter_chat_mock_app/widgets/input/phone_input.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/splash_base_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class SocialRegisterEnterPhoneSheet extends ConsumerStatefulWidget {
  final void Function(SplashActionSheet destinationSheet, {int? formTabIndex})
  changeSheet;

  const SocialRegisterEnterPhoneSheet({super.key, required this.changeSheet});

  @override
  ConsumerState<SocialRegisterEnterPhoneSheet> createState() =>
      _SocialRegisterEnterPhoneSheetState();
}

class _SocialRegisterEnterPhoneSheetState
    extends ConsumerState<SocialRegisterEnterPhoneSheet> {
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _phoneNumber = ref.read(socialRegisterDataProvider).phoneNumber ?? '';
  }

  Future<void> _handleContinueButtonTap(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final phoneNumber = PhoneNumberUtil.normalizeVietnamPhone(_phoneNumber);

    if (phoneNumber.isEmpty) {
      TO.show(context, l10n.signInPhoneEmpty);
      return;
    }

    if (!PhoneNumberUtil.isValidVietnamPhone(phoneNumber)) {
      TO.show(context, l10n.signUpInvalidPhone);
      return;
    }

    final serviceResponse = await AuthService.handleRequestOtp(
      phoneNumber,
      OtpType.registerGoogle.value,
    );
    if (!context.mounted) return;
    if (serviceResponse.isSuccess) {
      final current = ref.read(socialRegisterDataProvider);
      ref.read(socialRegisterDataProvider.notifier).state = current.copyWith(
        phoneNumber: phoneNumber,
      );
      widget.changeSheet(SplashActionSheet.socialRegisterEnterOtp);
      return;
    }
    TO.show(
      context,
      (serviceResponse.message?.trim().isNotEmpty == true)
          ? serviceResponse.message!
          : AppLocalizations.of(context)!.commonErrorTryAgain,
    );
  }

  Future<void> _handleBackButtonTap(BuildContext context) async {
    await AuthService.logoutGoogle();
    ref.invalidate(socialRegisterDataProvider);
    widget.changeSheet(SplashActionSheet.signInUp, formTabIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sheetContent = SizedBox(
      width: SizeConfig.sw(327),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeadingWithBackArrow(
            title: l10n.socialPhoneTitle,
            onBack: () => _handleBackButtonTap(context),
          ),
          SizedBox(height: SizeConfig.sh(8)),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: SizeConfig.sf(12) * 1.5 * 3),
            child: Text(
              l10n.socialPhoneSubtitle,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.sf(12),
                letterSpacing: 0.2,
                color: AC.greyText1,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.sh(16)),
          PhoneInput(
            initialValue: _phoneNumber,
            onChanged: (fullPhoneNumber) {
              setState(() => _phoneNumber = fullPhoneNumber);
            },
          ),
          SizedBox(height: SizeConfig.sh(16)),
          ActionButton(
            text: l10n.commonContinue,
            color: AppColors.greenStrong1,
            onTap: () => _handleContinueButtonTap(context),
          ),
        ],
      ),
    );

    return SplashBaseSheet(
      // height: SizeConfig.sh(636),
      height: SizeConfig.sh(653) + MQ.bottomPadding(context),
      topIconAsset: 'assets/images/icon_profile_splash.png',
      childWidget: sheetContent,
    );
  }
}
