import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/otp_type.dart';
import 'package:flutter_chat_mock_app/providers/social_register_data_provider.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/storage/last_login_phone_storage.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/heading_with_back_arrow.dart';
import 'package:flutter_chat_mock_app/widgets/number_input_field.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/splash_base_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class SocialRegisterEnterOtpSheet extends ConsumerStatefulWidget {
  final void Function()? onSocialRegisterSuccess;
  final void Function(SplashActionSheet nextSheet, {int? formTabIndex})
  changeSheet;

  const SocialRegisterEnterOtpSheet({
    super.key,
    this.onSocialRegisterSuccess,
    required this.changeSheet,
  });

  @override
  ConsumerState<SocialRegisterEnterOtpSheet> createState() =>
      _SocialRegisterEnterOtpSheetState();
}

class _SocialRegisterEnterOtpSheetState
    extends ConsumerState<SocialRegisterEnterOtpSheet> {
  final TextEditingController _otpController = TextEditingController();
  final LastLoginPhoneStorage _lastLoginPhoneStorage = LastLoginPhoneStorage();
  Timer? _timer;
  int _remainingSeconds = 10;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 10;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  Future<void> _handleResendPressed() async {
    if (!_canResend) return;
    final socialRegisterData = ref.read(socialRegisterDataProvider);
    final phone = socialRegisterData.phoneNumber;
    if (phone == null || phone.isEmpty) return;

    final serviceResponse = await AuthService.handleRequestOtp(
      phone,
      OtpType.registerGoogle.value,
    );
    if (!mounted) return;

    if (serviceResponse.isSuccess) {
      _startCountdown();
      return;
    }

    TO.show(
      context,
      (serviceResponse.message?.trim().isNotEmpty == true)
          ? serviceResponse.message!
          : AppLocalizations.of(context)!.commonErrorTryAgain,
    );
  }

  Future<void> _ontapButtonConfirmOtp(BuildContext context) async {
    final socialRegisterData = ref.read(socialRegisterDataProvider);
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      TO.show(context, AppLocalizations.of(context)!.forgotOtpHint);
      return;
    }

    final serviceResponse = await AuthService.handleSocialRegister(
      socialRegisterData,
      otp,
    );
    if (!context.mounted) return;
    if (serviceResponse.isSuccess) {
      final phone = socialRegisterData.phoneNumber;
      if (phone != null && phone.isNotEmpty) {
        await _lastLoginPhoneStorage.save(phone);
      }
      widget.onSocialRegisterSuccess?.call();
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
    final l10n = AppLocalizations.of(context)!;
    final socialRegisterData = ref.watch(socialRegisterDataProvider);

    final sheetContent = SizedBox(
      width: SizeConfig.sw(327),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeadingWithBackArrow(
            title: l10n.forgotOtpTitle,
            onBack: () {
              widget.changeSheet(SplashActionSheet.socialRegisterEnterPhone);
            },
          ),
          SizedBox(height: SizeConfig.sh(8)),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: SizeConfig.sf(12) * 1.5 * 3),
            child: Text(
              l10n.forgotOtpSubtitle(socialRegisterData.phoneNumber ?? ''),
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.sf(12),
                letterSpacing: 0.2,
                color: AC.greyText1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: SizeConfig.sh(16)),
          NumberInputField(
            hintText: l10n.forgotOtpHint,
            controller: _otpController,
          ),
          SizedBox(height: SizeConfig.sh(16)),
          TextButton(
            onPressed: _canResend ? _handleResendPressed : null,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.sf(12),
                  height: 20 / 12,
                  letterSpacing: 0.2,
                  color: AC.brownOtpAccent,
                ),
                children: [
                  TextSpan(text: l10n.forgotOtpResend),
                  if (!_canResend) ...[
                    TextSpan(text: ' ${l10n.forgotOtpIn} '),
                    TextSpan(
                      text: _formatTime(_remainingSeconds),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: SizeConfig.sh(16)),
          ActionButton(
            text: l10n.forgotOtpConfirm,
            color: AppColors.greenStrong1,
            onTap: () => _ontapButtonConfirmOtp(context),
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

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
