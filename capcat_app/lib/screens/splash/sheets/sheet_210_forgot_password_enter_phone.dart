import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/otp_type.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/phone_number_util.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/heading_with_back_arrow.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/input/phone_input.dart';
import 'package:flutter_chat_mock_app/widgets/splash_base_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/providers/forgot_password_data_provider.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class ForgotPasswordEnterPhoneSheet extends ConsumerStatefulWidget {
  final void Function(SplashActionSheet next, {int? formTabIndex}) changeSheet;

  const ForgotPasswordEnterPhoneSheet({super.key, required this.changeSheet});

  @override
  ConsumerState<ForgotPasswordEnterPhoneSheet> createState() =>
      _ForgotPasswordEnterPhoneSheetState();
}

class _ForgotPasswordEnterPhoneSheetState
    extends ConsumerState<ForgotPasswordEnterPhoneSheet> {
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _phoneNumber = ref.read(forgotPasswordDataProvider).phoneNumber ?? '';
  }

  Future<void> _onTapButtonContinue(BuildContext context) async {
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
      OtpType.forgotPassword.value,
    );
    if (!context.mounted) return;
    if (serviceResponse.isSuccess) {
      ref.read(forgotPasswordDataProvider.notifier).state = ref
          .read(forgotPasswordDataProvider)
          .copyWith(phoneNumber: phoneNumber);
      widget.changeSheet(SplashActionSheet.forgotPasswordEnterOtp);
      return;
    }
      TO.show(
        context,
        (serviceResponse.message?.trim().isNotEmpty == true)
            ? serviceResponse.message!
            : AppLocalizations.of(context)!.commonErrorTryAgain,
      );
    }

  @override
  Widget build(BuildContext context) {
    final double hp = 24;
    final double vp = 0;
    ref.watch(forgotPasswordDataProvider);

    final sheetContent = Container(
      padding: EdgeInsets.fromLTRB(hp, vp, hp, vp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeadingWithBackArrow(
              title: AppLocalizations.of(context)!.forgotPhoneTitle,
              onBack: () {
                ref.invalidate(forgotPasswordDataProvider);
                widget.changeSheet(SplashActionSheet.signInUp, formTabIndex: 0);
              },
            ),
            SizedBox(height: SizeConfig.sh(8)),
            Text(
              AppLocalizations.of(context)!.forgotPhoneSubtitle,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.sf(12),
                letterSpacing: 0.2,
                color: AC.greyText1,
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
              text: AppLocalizations.of(context)!.forgotPhoneContinue,
              onTap: () => _onTapButtonContinue(context),
            ),
          ],
        ),
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
