import 'package:flutter/material.dart';
import 'package:capcat_doca/enums/splash_action_sheet.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/input/input_field.dart';
import 'package:capcat_doca/widgets/button/action_button.dart';
import 'package:capcat_doca/widgets/splash_base_sheet.dart';
import 'package:capcat_doca/widgets/password/password_requirements_checklist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/providers/forgot_password_data_provider.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class ForgotPasswordEnterNewPasswordSheet extends ConsumerStatefulWidget {
  final void Function()? onChangeForgotPasswordSuccess;
  final void Function(SplashActionSheet next, {int? formTabIndex}) changeSheet;

  const ForgotPasswordEnterNewPasswordSheet({
    super.key,
    this.onChangeForgotPasswordSuccess,
    required this.changeSheet,
  });

  @override
  ConsumerState<ForgotPasswordEnterNewPasswordSheet> createState() =>
      _ForgotPasswordEnterNewPasswordSheetState();
}

class _ForgotPasswordEnterNewPasswordSheetState
    extends ConsumerState<ForgotPasswordEnterNewPasswordSheet> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _onTapButtonConfirm(BuildContext context) async {
    final forgotPasswordData = ref.read(forgotPasswordDataProvider);
    final phone = forgotPasswordData.phoneNumber;
    final otp = forgotPasswordData.otp;

    if (phone == null || otp == null) return;

    final newPassword = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final rulesResult = PasswordRulesResult.from(newPassword);
    if (!rulesResult.hasLength ||
        !rulesResult.hasNumber ||
        !rulesResult.hasUpperCase) {
      TO.show(
        context,
        AppLocalizations.of(context)!.forgotNewPasswordRulesError,
      );
      return;
    }
    if (newPassword != confirmPassword) {
      TO.show(
        context,
        AppLocalizations.of(context)!.forgotNewPasswordMismatch,
      );
      return;
    }
    final serviceResponse = await AuthService.handleChangeForgotPassword(
      phone,
      otp,
      newPassword,
    );
    if (!context.mounted) return;
    if (serviceResponse.isSuccess) {
      widget.onChangeForgotPasswordSuccess?.call();
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
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double hp = 24;
    final double vp = 0;

    final sheetContent = Container(
      padding: EdgeInsets.fromLTRB(hp, vp, hp, vp),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.forgotNewPasswordTitle,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.sf(24),
                color: AC.blackText1,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: SizeConfig.sh(8)),
            Text(
              AppLocalizations.of(context)!.forgotNewPasswordSubtitle,
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
              hintText: AppLocalizations.of(context)!.forgotNewPasswordHint,
              iconPath: 'assets/icons/splash-lock.png',
              controller: _passwordController,
              // obscureText: true,
              isPasswordField: true,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: SizeConfig.sh(16)),
            InputField(
              hintText: AppLocalizations.of(context)!.forgotNewPasswordConfirmHint,
              iconPath: 'assets/icons/splash-lock.png',
              controller: _confirmPasswordController,
              // obscureText: true,
              isPasswordField: true,
            ),
            SizedBox(height: SizeConfig.sh(16)),
            PasswordRequirementsChecklist(password: _passwordController.text),
            SizedBox(height: SizeConfig.sh(16)),
            ActionButton(
              text: AppLocalizations.of(context)!.forgotNewPasswordButton,
              color: AppColors.greenStrong1,
              onTap: () => _onTapButtonConfirm(context),
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
