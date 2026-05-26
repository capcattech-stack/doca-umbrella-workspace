import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/splash_action_sheet.dart';
import 'package:flutter_chat_mock_app/screens/main/main_screen.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/dialog_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/utils/transition_config.dart';
import 'package:flutter_chat_mock_app/widgets/keyboard_dismisser.dart';
import 'package:flutter_chat_mock_app/screens/splash/sheets/sheet_000_intro.dart';
import 'package:flutter_chat_mock_app/screens/splash/sheets/sheet_100_sign_in_up.dart';
import 'package:flutter_chat_mock_app/screens/splash/sheets/sheet_210_forgot_password_enter_phone.dart';
import 'package:flutter_chat_mock_app/screens/splash/sheets/sheet_211_forgot_password_enter_otp.dart';
import 'package:flutter_chat_mock_app/screens/splash/sheets/sheet_212_forgot_password_enter_new_password.dart';
import 'package:flutter_chat_mock_app/screens/splash/sheets/sheet_220_social_register_enter_phone.dart';
import 'package:flutter_chat_mock_app/screens/splash/sheets/sheet_221_social_register_enter_otp.dart';
import 'package:flutter_chat_mock_app/screens/splash/sheets/sheet_310_phone_register_enter_otp.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class SplashScreenWithPageController extends StatefulWidget {
  const SplashScreenWithPageController({super.key});

  @override
  State<SplashScreenWithPageController> createState() =>
      _SplashScreenWithPageControllerState();
}

class _SplashScreenWithPageControllerState
    extends State<SplashScreenWithPageController>
    with TickerProviderStateMixin {
  final List<String> assetPaths = [
    'assets/flags/VN.png',
    'assets/images/icon_profile_splash.png',
    'assets/images/icon_edit_splash.png',
    'assets/images/splash_screen_logo.png',
    'assets/images/splash_screen_doggo.png',
    'assets/images/google_button_logo.png',
  ];
  bool _animate = false;
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  late final PageController _pageController;

  int _signInUpFormTabIndex = 0;

  final List<SplashActionSheet> _sheetOrder = [
    SplashActionSheet.intro,
    SplashActionSheet.signInUp,
    SplashActionSheet.forgotPasswordEnterPhone,
    SplashActionSheet.forgotPasswordEnterOtp,
    SplashActionSheet.forgotPasswordEnterNewPassword,
    SplashActionSheet.phoneRegisterEnterOtp,
    SplashActionSheet.socialRegisterEnterPhone,
    SplashActionSheet.socialRegisterEnterOtp,
  ];

  late final Map<SplashActionSheet, Widget Function()> _sheetBuilders;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheAllAssets(context);
    });

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: TransitionConfig.durationLong),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _pageController = PageController(initialPage: 0);

    _sheetBuilders = {
      SplashActionSheet.intro: () => IntroSheet(changeSheet: _changeSheet),
      SplashActionSheet.signInUp: () => SignInUpSheet(
        changeSheet: _changeSheet,
        initialFormTabIndex: _signInUpFormTabIndex,
        onPhoneLoginSuccess: _onPhoneLoginSuccess,
        onSocialLoginSuccess: _onSocialLoginSuccess,
      ),
      SplashActionSheet.forgotPasswordEnterPhone: () =>
          ForgotPasswordEnterPhoneSheet(changeSheet: _changeSheet),
      SplashActionSheet.forgotPasswordEnterOtp: () =>
          ForgotPasswordEnterOtpSheet(changeSheet: _changeSheet),
      SplashActionSheet.forgotPasswordEnterNewPassword: () =>
          ForgotPasswordEnterNewPasswordSheet(
            changeSheet: _changeSheet,
            onChangeForgotPasswordSuccess: _onChangeForgotPasswordSuccess,
          ),
      SplashActionSheet.socialRegisterEnterPhone: () =>
          SocialRegisterEnterPhoneSheet(changeSheet: _changeSheet),
      SplashActionSheet.socialRegisterEnterOtp: () =>
          SocialRegisterEnterOtpSheet(
            changeSheet: _changeSheet,
            onSocialRegisterSuccess: _onSocialRegisterSuccess,
          ),
      SplashActionSheet.phoneRegisterEnterOtp: () => PhoneRegisterEnterOtpSheet(
        changeSheet: _changeSheet,
        onPhoneRegisterSuccess: _onPhoneRegisterSuccess,
      ),
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SizeConfig.init(context);
      precacheImage(
        const AssetImage('assets/images/splash_screen_logo.png'),
        context,
      );
      precacheImage(
        const AssetImage('assets/images/splash_screen_doggo.png'),
        context,
      );
    });

    Timer(const Duration(seconds: 4), () {
      setState(() => _animate = true);
      _slideController.forward();
    });
  }

  void precacheAllAssets(BuildContext context) {
    for (final path in assetPaths) {
      precacheImage(AssetImage(path), context);
    }
  }

  void _changeSheet(SplashActionSheet next, {int? formTabIndex}) {
    if (!_sheetOrder.contains(next)) return;
    final pageIndex = _sheetOrder.indexOf(next);

    if (formTabIndex != null && next == SplashActionSheet.signInUp) {
      _signInUpFormTabIndex = formTabIndex;
    }

    // setState(() => _currentSheet = next);

    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: TransitionConfig.durationShort),
      curve: Curves.easeInOut,
    );
  }

  void _onPhoneLoginSuccess() {
    final l10n = AppLocalizations.of(context)!;
    TO.show(context, l10n.toastLoginSuccess);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  void _onSocialLoginSuccess() {
    final l10n = AppLocalizations.of(context)!;
    TO.show(context, l10n.toastLinkLoginSuccess);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  void _onPhoneRegisterSuccess() {
    final l10n = AppLocalizations.of(context)!;
    TO.show(context, l10n.toastRegisterSuccess);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  void _onSocialRegisterSuccess() {
    final l10n = AppLocalizations.of(context)!;
    TO.show(context, l10n.toastLinkRegisterSuccess);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  void _onChangeForgotPasswordSuccess() {
    final l10n = AppLocalizations.of(context)!;
    TO.show(context, l10n.toastChangePasswordSuccess);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final topHeight = SizeConfig.sh(213);
    final safeTop = MediaQuery.of(context).padding.top;

    return KeyboardDismisser(
      child: CustomScaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(
                milliseconds: TransitionConfig.durationLong,
              ),
              curve: Curves.easeInOut,
              top: _animate ? safeTop : topHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: RepaintBoundary(
                child: ClipRect(
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/images/splash_screen_doggo.png',
                      width: SizeConfig.sw(375),
                      fit: BoxFit.fill,
                      alignment: Alignment.topRight,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(
                milliseconds: TransitionConfig.durationLong,
              ),
              curve: Curves.easeInOut,
              top: _animate ? -topHeight : safeTop,
              left: 0,
              right: 0,
              height: topHeight,
              child: RepaintBoundary(
                child: Center(
                  child: Image.asset(
                    'assets/images/splash_screen_logo.png',
                    width: SizeConfig.sw(240),
                    height: SizeConfig.sh(80),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _slideAnimation,
              child: RepaintBoundary(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _sheetOrder.length,
                  itemBuilder: (context, index) {
                    final sheet = _sheetOrder[index];
                    return _sheetBuilders[sheet]!();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
