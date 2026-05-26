import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/social_login_platform.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/providers/loading_overlay_provider.dart';
import 'package:flutter_chat_mock_app/providers/locale_provider.dart';
import 'package:flutter_chat_mock_app/providers/phone_login_data_provider.dart';
import 'package:flutter_chat_mock_app/providers/social_register_data_provider.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/storage/last_login_phone_storage.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/phone_number_util.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/input/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/input/phone_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class SignInForm extends ConsumerStatefulWidget {
  final void Function()? onPhoneLoginSuccess;
  final void Function()? onSocialLoginSuccess;
  final void Function()? onSocialLoginNotFound;
  final void Function(SplashActionSheet next, {int? formTabIndex}) changeSheet;

  const SignInForm({
    super.key,
    this.onPhoneLoginSuccess,
    this.onSocialLoginSuccess,
    this.onSocialLoginNotFound,
    required this.changeSheet,
  });

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LastLoginPhoneStorage _lastLoginPhoneStorage = LastLoginPhoneStorage();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final savedPhone = ref.read(phoneLoginDataProvider).phoneNumber;

    if (savedPhone != null && savedPhone.isNotEmpty) {
      _assignPhone(savedPhone, notifyProvider: false, rebuild: false);
    } else {
      _loadLastLoginPhone();
    }
  }

  Future<void> _loadLastLoginPhone() async {
    final storedPhone = await _lastLoginPhoneStorage.read();
    if (!mounted) return;
    if (storedPhone != null && storedPhone.isNotEmpty) {
      _assignPhone(storedPhone);
    }
  }

  void _assignPhone(
    String phoneNumber, {
    bool notifyProvider = true,
    bool rebuild = true,
  }) {
    _phoneController.text = phoneNumber;
    if (notifyProvider) {
      final currentData = ref.read(phoneLoginDataProvider);
      ref.read(phoneLoginDataProvider.notifier).state = currentData.copyWith(
        phoneNumber: phoneNumber,
      );
    }
    if (rebuild && mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  bool isValidLogin(String phoneNumber, String password) {
    final l10n = AppLocalizations.of(context)!;
    if (phoneNumber.isEmpty) {
      _showMessage(l10n.signInPhoneEmpty);
      return false;
    }

    if (password.isEmpty) {
      _showMessage(l10n.signInPasswordEmpty);
      return false;
    }

    // if (!isValidVietnamPhone(phoneNumber)) {
    //   _showMessage('Số điện thoại không hợp lệ');
    //   return false;
    // }

    // if (!isValidPassword(password)) {
    //   _showMessage('Mật khẩu phải có ít nhất 6 ký tự');
    //   return false;
    // }
    return true;
  }

  void _showMessage(String message) {
    TO.show(context, message);
  }

  Future<void> _handlePhoneLogin(
    BuildContext context,
    String phoneNumber,
    String password,
  ) async {
    if (!isValidLogin(phoneNumber, password)) {
      return;
    }

    //--Loại bỏ số 0 sau mã vùng, nếu có
    phoneNumber = PhoneNumberUtil.normalizeVietnamPhone(phoneNumber);

    final serviceResponse = await AuthService.loginPhone(phoneNumber, password);
    if (!context.mounted) return;

    if (serviceResponse.isSuccess) {
      await _lastLoginPhoneStorage.save(phoneNumber);
      _assignPhone(phoneNumber, rebuild: false);
      widget.onPhoneLoginSuccess?.call();
      return;
    }

    TO.show(
      context,
      serviceResponse.message ?? 'Đã có lỗi, vui lòng thử lại sau',
    );
  }

  Future<void> _handleSocialLogin(
    BuildContext context,
    String socialPlatform,
  ) async {
    final overlay = ref.read(loadingOverlayProvider.notifier);

    //--Loading overlay
    overlay.show('');
    final serviceResponse = await AuthService.handleSocialLogin(
      socialPlatform,
      onMessageUpdate: (msg) {
        overlay.updateMessage(msg);
      },
    );
    overlay.hide();
    if (!context.mounted) return;
    if (serviceResponse.isSuccess) {
      widget.onSocialLoginSuccess?.call();
      return;
    }
    if (serviceResponse.message == 'user_not_found') {
      //--Save Social Register data
      ref.read(socialRegisterDataProvider.notifier).state =
          serviceResponse.data;
      widget.onSocialLoginNotFound?.call();
      return;
    }
    TO.show(
      context,
      (serviceResponse.message?.trim().isNotEmpty == true)
          ? serviceResponse.message!
          : 'Đã có lỗi, vui lòng thử lại sau',
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final hp = SC.sw(24);
    final l10n = AppLocalizations.of(context)!;
    ref.watch(localeProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(hp, 0, hp, 0),
      child:
          // Stack(
          //   children: [
          SingleChildScrollView(
            child: Column(
              key: const ValueKey('sign_in_form'),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: SizeConfig.sh(24)),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: _WelcomeText(),
                ),
                SizedBox(height: SizeConfig.sh(16)),
                PhoneInput(
                  initialValue: _phoneController.text,
                  onChanged: (fullPhoneNumber) {
                    _phoneController.text = fullPhoneNumber;
                    final currentData = ref.read(phoneLoginDataProvider);
                    ref.read(phoneLoginDataProvider.notifier).state =
                        currentData.copyWith(phoneNumber: fullPhoneNumber);
                  },
                ),
                SizedBox(height: SizeConfig.sh(16)),
                InputField(
                  hintText: l10n.signInPasswordHint,
                  iconPath: 'assets/icons/splash-lock.png',
                  controller: _passwordController,
                  // obscureText: true,
                  isPasswordField: true,
                ),
                SizedBox(height: SizeConfig.sh(16)),
                _buildForgotPasswordClickableText(context),
                SizedBox(height: SizeConfig.sh(16)),
                ActionButton(
                  text: l10n.signInButton,
                  color: AppColors.greenStrong1,
                  onTap: () {
                    _handlePhoneLogin(
                      context,
                      _phoneController.text.trim(),
                      _passwordController.text,
                    );
                  },
                ),
                SizedBox(height: SizeConfig.sh(16)),
                const _DividerWithText(),
                SizedBox(height: SizeConfig.sh(16)),
                ActionButton(
                  leadingIcon: Image.asset(
                    'assets/images/google_button_logo.png',
                  ),
                  text: l10n.signInWithGoogle,
                  color: AppColors.white,
                  borderColor: AC.greyBorder2,
                  textColor: AC.blackText2,
                  onTap: () =>
                      _handleSocialLogin(context, SocialPlatform.google.value),
                ),
                SizedBox(height: SizeConfig.sh(140)),
              ],
            ),
          ),
      // Positioned(
      //   bottom: MQ.bottomPadding(context),
      //   right: 0,
      //   child: SizedBox(
      //     width: SC.sw(160),
      //     child: TabSelector(
      //       selectedIndex: locale.languageCode == 'en' ? 0 : 1,
      //       width: SC.sw(160),
      //       labels: const ['ENG', 'VIE'],
      //       onTabChanged: (index) {
      //         if (index == 0) {
      //           ref
      //               .read(localeProvider.notifier)
      //               .setLocale(const Locale('en'));
      //         } else {
      //           ref
      //               .read(localeProvider.notifier)
      //               .setLocale(const Locale('vi'));
      //         }
      //       },
      //     ),
      //   ),
      // ),
      //   ],
      // ),
    );
  }

  Widget _buildForgotPasswordClickableText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text.rich(
      TextSpan(
        text: l10n.signInForgotPrefix,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'Quicksand',
          fontSize: SizeConfig.sf(12),
          color: AC.neutralSigninTitle,
        ),
        children: [
          TextSpan(
            text: l10n.signInForgotLink,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'Quicksand',
              fontSize: SizeConfig.sf(12),
              color: AC.neutralSigninTitle,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                widget.changeSheet(SplashActionSheet.forgotPasswordEnterPhone);
              },
          ),
        ],
      ),
      textAlign: TextAlign.center,
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
            l10n.signInTitle,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
              fontSize: SizeConfig.sf(24),
              color: AC.blackText1,
            ),
          ),
          SizedBox(height: SizeConfig.sh(8)),
          Text(
            l10n.signInDescription,
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

class _DividerWithText extends StatelessWidget {
  const _DividerWithText();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Expanded(child: Divider(color: AC.greyBorder1, thickness: 1)),
        Container(color: AC.greyBorder1, width: SC.sw(96), height: SC.sh(1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            l10n.signInOr,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: SizeConfig.sf(12),
              color: AC.neutralSigninMeta,
            ),
          ),
        ),
        Container(color: AC.greyBorder1, width: SC.sw(96), height: SC.sh(1)),
        // Expanded(child: Divider(color: AC.greyBorder1, thickness: 1)),
      ],
    );
  }
}
