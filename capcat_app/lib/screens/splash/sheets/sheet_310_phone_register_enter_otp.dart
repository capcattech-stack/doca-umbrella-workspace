import 'dart:async';
import 'package:flutter/material.dart';
import 'package:capcat_doca/enums/otp_type.dart';
import 'package:capcat_doca/enums/splash_action_sheet.dart';
import 'package:capcat_doca/providers/phone_register_data_provider.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/storage/last_login_phone_storage.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/heading_with_back_arrow.dart';
import 'package:capcat_doca/widgets/button/action_button.dart';
import 'package:capcat_doca/widgets/input/input_field.dart';
import 'package:capcat_doca/widgets/splash_base_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class PhoneRegisterEnterOtpSheet extends ConsumerStatefulWidget {
  final void Function()? onPhoneRegisterSuccess;
  final void Function(SplashActionSheet nextSheet, {int? formTabIndex})
  changeSheet;

  const PhoneRegisterEnterOtpSheet({
    super.key,
    this.onPhoneRegisterSuccess,
    required this.changeSheet,
  });

  @override
  ConsumerState<PhoneRegisterEnterOtpSheet> createState() =>
      _PhoneRegisterEnterOtpSheetState();
}

class _PhoneRegisterEnterOtpSheetState
    extends ConsumerState<PhoneRegisterEnterOtpSheet> {
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

  void _handleResendPressed() async {
    if (!_canResend) return;
    debugPrint('Gửi lại mã');
    _startCountdown();

    final splashData = ref.read(phoneRegisterDataProvider);
    final phone = splashData.phoneNumber;

    if (phone != null) {
      final serviceResponse = await AuthService.handleRequestOtp(
        phone,
        OtpType.register.value,
      );
      if (!mounted) return;
      if (serviceResponse.isSuccess) {
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

  Future<void> _handlePhoneRegister(BuildContext context) async {
    final splashData = ref.read(phoneRegisterDataProvider);
    final name = splashData.name;
    final phone = splashData.phoneNumber;
    final password = splashData.password;
    final otp = _otpController.text;

    if (name == null || phone == null || password == null) {
      return;
    }

    if (otp.isEmpty) {
      // DialogUtils.showErrorDialog(
      //   context,
      //   title: AppLocalizations.of(context)!.forgotOtpTitle,
      //   message: '',
      // );
      TO.show(context, AppLocalizations.of(context)!.forgotOtpTitle);
      return;
    }

    final serviceResponse = await AuthService.registerPhone(
      name,
      phone,
      password,
      otp,
    );

    if (!context.mounted) return;
    if (serviceResponse.isSuccess) {
      await _lastLoginPhoneStorage.save(phone);
      widget.onPhoneRegisterSuccess?.call();
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
    final l10n = AppLocalizations.of(context)!;
    final phoneRegisterData = ref.watch(phoneRegisterDataProvider);

    final sheetContent = Container(
      padding: EdgeInsets.fromLTRB(hp, vp, hp, vp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeadingWithBackArrow(
              title: l10n.forgotOtpTitle,
              onBack: () {
                widget.changeSheet(SplashActionSheet.signInUp, formTabIndex: 1);
              },
            ),
            SizedBox(height: SizeConfig.sh(8)),
            Text(
              l10n.phoneRegisterOtpSubtitle(
                phoneRegisterData.phoneNumber ?? l10n.commonBack,
              ),
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.sf(12),
                letterSpacing: 0.2,
                color: AC.greyText1,
              ),
              textAlign: TextAlign.start,
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
            ),
            SizedBox(height: SizeConfig.sh(16)),
            ActionButton(
              text: l10n.forgotOtpConfirm,
              onTap: () => _handlePhoneRegister(context),
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

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
