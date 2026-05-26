import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/otp_type.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/providers/phone_register_data_provider.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/phone_number_util.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/input/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/input/phone_input.dart';
import 'package:flutter_chat_mock_app/widgets/password/password_requirements_checklist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class SignUpForm extends ConsumerStatefulWidget {
  final void Function(SplashActionSheet next, {int? formTabIndex}) changeSheet;

  const SignUpForm({super.key, required this.changeSheet});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final phoneRegisterData = ref.read(phoneRegisterDataProvider);
    _nameController = TextEditingController(text: phoneRegisterData.name ?? '');
    _phoneController = TextEditingController(
      text: phoneRegisterData.phoneNumber ?? '',
    );
    _passwordController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePhoneRegisterData({
    String? phoneRegisterName,
    String? phoneRegisterPhoneNumber,
    String? phoneRegisterPassword,
  }) {
    final current = ref.read(phoneRegisterDataProvider);
    ref.read(phoneRegisterDataProvider.notifier).state = current.copyWith(
      name: phoneRegisterName,
      phoneNumber: phoneRegisterPhoneNumber,
      password: phoneRegisterPassword,
    );
  }

  void _handleRegisterButtonTap() async {
    String name = _nameController.text;
    String phone = PhoneNumberUtil.normalizeVietnamPhone(_phoneController.text);
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    if (!isValidRegistration(phone, password, confirmPassword)) {
      return;
    }
    _updatePhoneRegisterData(
      phoneRegisterName: name,
      phoneRegisterPhoneNumber: phone,
      phoneRegisterPassword: password,
    );
    final serviceResponse = await AuthService.handleRequestOtp(
      phone,
      OtpType.register.value,
    );
    if (!mounted) return;
    if (serviceResponse.isSuccess) {
      widget.changeSheet(SplashActionSheet.phoneRegisterEnterOtp);
      return;
    }
    TO.show(
      context,
      (serviceResponse.message?.trim().isNotEmpty == true)
          ? serviceResponse.message!
          : 'Đã có lỗi, vui lòng thử lại sau',
    );
  }

  bool isValidPassword(String password) {
    final rulesResult = PasswordRulesResult.from(password);
    return rulesResult.hasLength &&
        rulesResult.hasNumber &&
        rulesResult.hasUpperCase;
  }

  bool isValidRegistration(
    String phoneNumber,
    String password,
    String confirmPassword,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (phoneNumber.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage(l10n.signUpFillAll);
      return false;
    }

    if (!PhoneNumberUtil.isValidVietnamPhone(phoneNumber)) {
      _showMessage(l10n.signUpInvalidPhone);
      return false;
    }

    if (!isValidPassword(password)) {
      _showMessage(l10n.signUpPasswordRuleError);
      return false;
    }

    if (password != confirmPassword) {
      _showMessage(l10n.signUpPasswordMismatch);
      return false;
    }
    return true;
  }

  void _showMessage(String message) {
    TO.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final hp = SC.sw(24);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 0, hp, 0),
      child: SingleChildScrollView(
        child: Column(
          key: const ValueKey('sign_up_form'),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.sh(24)),
            const Align(alignment: Alignment.centerLeft, child: _WelcomeText()),
            SizedBox(height: SizeConfig.sh(16)),
            InputField(
              hintText: l10n.signUpNameHint,
              iconPath: 'assets/icons/splash-profile.png',
              controller: _nameController,
              onChanged: (name) =>
                  _updatePhoneRegisterData(phoneRegisterName: name),
            ),
            SizedBox(height: SizeConfig.sh(16)),
            PhoneInput(
              initialValue: _phoneController.text,
              onChanged: (fullPhoneNumber) {
                _phoneController.text = fullPhoneNumber;
                _updatePhoneRegisterData(
                  phoneRegisterPhoneNumber: fullPhoneNumber,
                );
              },
            ),
            SizedBox(height: SizeConfig.sh(16)),
            InputField(
              hintText: l10n.signUpPasswordHint,
              iconPath: 'assets/icons/splash-lock.png',
              controller: _passwordController,
              // obscureText: true,
              isPasswordField: true,
              onChanged: (password) {
                _updatePhoneRegisterData(phoneRegisterPassword: password);
                setState(() {});
              },
            ),
            SizedBox(height: SizeConfig.sh(16)),
            InputField(
              hintText: l10n.signUpPasswordConfirmHint,
              iconPath: 'assets/icons/splash-lock.png',
              controller: _confirmPasswordController,
              // obscureText: true,
              isPasswordField: true,
            ),
            SizedBox(height: SizeConfig.sh(16)),
            PasswordRequirementsChecklist(password: _passwordController.text),
            SizedBox(height: SizeConfig.sh(24)),
            ActionButton(
              text: l10n.signUpButton,
              onTap: _handleRegisterButtonTap,
            ),
            SizedBox(height: SizeConfig.physicPaddingBottom),
          ],
        ),
      ),
    );
  }
}

class _WelcomeText extends StatelessWidget {
  const _WelcomeText();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: SC.sh(64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            l10n.signUpTitle,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
              fontSize: SizeConfig.sf(24),
              color: AC.blackText1,
            ),
          ),
          SizedBox(height: SizeConfig.sh(8)),
          Text(
            l10n.signUpDescription,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.sf(12),
              letterSpacing: 0.2,
              color: AC.greyText1,
            ),
          ),
        ],
      ),
    );
  }
}
