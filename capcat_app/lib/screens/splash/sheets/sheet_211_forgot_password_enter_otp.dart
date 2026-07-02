import 'dart:async';
import 'package:flutter/material.dart';
import 'package:capcat_doca/enums/otp_type.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/enums/splash_action_sheet.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/heading_with_back_arrow.dart';
import 'package:capcat_doca/widgets/button/action_button.dart';
import 'package:capcat_doca/widgets/input/input_field.dart';
import 'package:capcat_doca/widgets/splash_base_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/providers/forgot_password_data_provider.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class ForgotPasswordEnterOtpSheet extends ConsumerStatefulWidget {
  final void Function(SplashActionSheet nextSheet, {int? formTabIndex})
  changeSheet;

  const ForgotPasswordEnterOtpSheet({super.key, required this.changeSheet});

  @override
  ConsumerState<ForgotPasswordEnterOtpSheet> createState() =>
      _ForgotPasswordEnterOtpSheetState();
}

class _ForgotPasswordEnterOtpSheetState
    extends ConsumerState<ForgotPasswordEnterOtpSheet> {
  final TextEditingController _otpController = TextEditingController();
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
        setState(() => _canResend = true);
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _handleResendPressed() async {
    if (!_canResend) return;

    final splashData = ref.read(forgotPasswordDataProvider);
    final phone = splashData.phoneNumber;

    if (phone != null) {
      final serviceResponse = await AuthService.handleRequestOtp(
        phone,
        OtpType.forgotPassword.value,
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
  }

  Future<void> _onTapButtonContinue(BuildContext context) async {
    final forgotPasswordData = ref.read(forgotPasswordDataProvider);
    final l10n = AppLocalizations.of(context)!;

    final phone = forgotPasswordData.phoneNumber;
    if (phone == null || phone.isEmpty) return;

    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      TO.show(context, l10n.forgotOtpHint);
      return;
    }

    final serviceResponse = await AuthService.handleVerifyOtp(phone, otp);
    if (!context.mounted) return;

    if (serviceResponse.isSuccess) {
      ref.read(forgotPasswordDataProvider.notifier).state = forgotPasswordData
          .copyWith(otp: otp);
      widget.changeSheet(SplashActionSheet.forgotPasswordEnterNewPassword);
      return;
    }

    TO.show(
      context,
      (serviceResponse.message?.trim().isNotEmpty == true)
          ? serviceResponse.message!
          : l10n.commonErrorTryAgain,
    );
  }

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final double hp = 24;
    final double vp = 0;
    final forgotPasswordData = ref.watch(forgotPasswordDataProvider);
    final l10n = AppLocalizations.of(context)!;

    final sheetContent = Container(
      padding: EdgeInsets.fromLTRB(hp, vp, hp, vp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeadingWithBackArrow(
              title: l10n.forgotOtpTitle,
              onBack: () {
                widget.changeSheet(SplashActionSheet.forgotPasswordEnterPhone);
              },
            ),
            SizedBox(height: SizeConfig.sh(8)),
            Text(
              l10n.forgotOtpSubtitle(forgotPasswordData.phoneNumber ?? ''),
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.sf(12),
                letterSpacing: 0.2,
                color: AC.greyText1,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: SizeConfig.sh(16)),
            InputField(
              hintText: l10n.forgotOtpHint,
              controller: _otpController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: SizeConfig.sh(16)),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: _canResend ? _handleResendPressed : null,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.sf(12),
                      height: 20 / 12,
                      letterSpacing: 0.2,
                    color: _canResend ? AC.greenText1 : AC.greyText4,
                  ),
                  children: [
                    TextSpan(
                      text: l10n.forgotOtpResend,
                    ),
                    if (!_canResend) ...[
                      TextSpan(
                        text: ' ${l10n.forgotOtpIn} ',
                      ),
                      TextSpan(
                        text: _formatTime(_remainingSeconds),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.sh(16)),
            ActionButton(
              text: l10n.forgotOtpConfirm,
              color: AppColors.greenStrong1,
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
