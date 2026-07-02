import 'dart:async';
import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/enums/splash_action_sheet.dart';
import 'package:capcat_doca/providers/chat_pet_provider.dart';
import 'package:capcat_doca/providers/forgot_password_data_provider.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart';
import 'package:capcat_doca/providers/list_conversation_provider.dart';
import 'package:capcat_doca/providers/login_method_provider.dart';
import 'package:capcat_doca/providers/moments_provider.dart';
import 'package:capcat_doca/providers/nanny_chat_provider.dart';
import 'package:capcat_doca/providers/phone_register_data_provider.dart';
import 'package:capcat_doca/providers/social_register_data_provider.dart';
import 'package:capcat_doca/providers/user_detail_provider.dart';
import 'package:capcat_doca/screens/main/main_screen.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/utils/transition_config.dart';
import 'package:capcat_doca/widgets/keyboard_dismisser.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:capcat_doca/screens/splash/sheets/sheet_000_intro.dart';
import 'package:capcat_doca/screens/splash/sheets/sheet_100_sign_in_up.dart';
import 'package:capcat_doca/screens/splash/sheets/sheet_210_forgot_password_enter_phone.dart';
import 'package:capcat_doca/screens/splash/sheets/sheet_211_forgot_password_enter_otp.dart';
import 'package:capcat_doca/screens/splash/sheets/sheet_212_forgot_password_enter_new_password.dart';
import 'package:capcat_doca/screens/splash/sheets/sheet_220_social_register_enter_phone.dart';
import 'package:capcat_doca/screens/splash/sheets/sheet_221_social_register_enter_otp.dart';
import 'package:capcat_doca/screens/splash/sheets/sheet_310_phone_register_enter_otp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';

class SplashScreenWithAnimationController extends ConsumerStatefulWidget {
  final SplashActionSheet initialSheet;
  const SplashScreenWithAnimationController({
    super.key,
    this.initialSheet = SplashActionSheet.intro,
  });

  @override
  ConsumerState<SplashScreenWithAnimationController> createState() =>
      _SplashScreenWithAnimationControllerState();
}

class _SplashScreenWithAnimationControllerState
    extends ConsumerState<SplashScreenWithAnimationController>
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
  bool _isAnimating = false;
  bool _isForward = true;

  late final AnimationController _actionSheetController;
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _pageController;
  late Animation<Offset> _currentPageOffset;
  late Animation<Offset> _nextPageOffset;

  late SplashActionSheet _currentSheet;
  late SplashActionSheet _nextSheet;

  int _signInUpFormTabIndex = 0;

  final _sheetOrder = [
    SplashActionSheet.intro,
    SplashActionSheet.signInUp,
    SplashActionSheet.forgotPasswordEnterPhone,
    SplashActionSheet.forgotPasswordEnterOtp,
    SplashActionSheet.forgotPasswordEnterNewPassword,
    SplashActionSheet.phoneRegisterEnterOtp,
    SplashActionSheet.socialRegisterEnterPhone,
    SplashActionSheet.socialRegisterEnterOtp,
  ];

  final _rebuildAlwaysSheets = {
    SplashActionSheet.phoneRegisterEnterOtp,
    SplashActionSheet.socialRegisterEnterPhone,
    SplashActionSheet.socialRegisterEnterOtp,
    SplashActionSheet.forgotPasswordEnterOtp,
    SplashActionSheet.forgotPasswordEnterNewPassword,
  };

  final Map<SplashActionSheet, Widget Function()> _sheetBuilders = {};
  final Map<SplashActionSheet, Widget> _sheetInstances = {};

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _currentSheet = widget.initialSheet;
    _nextSheet = _currentSheet;

    _actionSheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: TransitionConfig.durationLong),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _actionSheetController,
            curve: Curves.easeOutCubic,
          ),
        );

    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: TransitionConfig.durationShort),
    );

    _registerSheetBuilders();
    _precacheAllAssets();

    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (!mounted) return;
      setState(() => _animate = true);
      _actionSheetController.forward();
    });
  }

  @override
  void dispose() {
    _actionSheetController.dispose();
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void _precacheAllAssets() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final path in assetPaths) {
        precacheImage(AssetImage(path), context);
      }
    });
  }

  void _registerSheetBuilders() {
    _sheetBuilders[SplashActionSheet.intro] = () =>
        IntroSheet(changeSheet: _changeSheet);
    _sheetBuilders[SplashActionSheet.signInUp] = () => SignInUpSheet(
      changeSheet: _changeSheet,
      initialFormTabIndex: _signInUpFormTabIndex,
      onPhoneLoginSuccess: _onPhoneLoginSuccess,
      onSocialLoginSuccess: _onSocialLoginSuccess,
    );
    _sheetBuilders[SplashActionSheet.forgotPasswordEnterPhone] = () =>
        ForgotPasswordEnterPhoneSheet(changeSheet: _changeSheet);
    _sheetBuilders[SplashActionSheet.forgotPasswordEnterOtp] = () =>
        ForgotPasswordEnterOtpSheet(changeSheet: _changeSheet);
    _sheetBuilders[SplashActionSheet.forgotPasswordEnterNewPassword] = () =>
        ForgotPasswordEnterNewPasswordSheet(
          changeSheet: _changeSheet,
          onChangeForgotPasswordSuccess: _onChangeForgotPasswordSuccess,
        );
    _sheetBuilders[SplashActionSheet.socialRegisterEnterPhone] = () =>
        SocialRegisterEnterPhoneSheet(changeSheet: _changeSheet);
    _sheetBuilders[SplashActionSheet.socialRegisterEnterOtp] = () =>
        SocialRegisterEnterOtpSheet(
          changeSheet: _changeSheet,
          onSocialRegisterSuccess: _onSocialRegisterSuccess,
        );
    _sheetBuilders[SplashActionSheet.phoneRegisterEnterOtp] = () =>
        PhoneRegisterEnterOtpSheet(
          changeSheet: _changeSheet,
          onPhoneRegisterSuccess: _onPhoneRegisterSuccess,
        );

    for (var entry in _sheetBuilders.entries) {
      _sheetInstances[entry.key] = entry.value();
    }
  }

  Future<void> _refreshUserAndPets() async {
    await ref.read(userDetailProvider.notifier).refresh();
    try {
      final _ = await ref.refresh(listPetDetailProvider.future);
    } catch (err) {
      debugPrint('[Splash] Failed to refresh pet list: $err');
    }
    try {
      await ref.read(momentsProvider.notifier).refresh();
    } catch (err) {
      debugPrint('[Splash] Failed to refresh moments: $err');
    }
    try {
      await ref.read(listConversationProvider.notifier).refresh();
    } catch (err) {
      debugPrint('[Splash] Failed to refresh conversations: $err');
    }
    try {
      await ref.read(chatPetListProvider.notifier).refresh();
    } catch (err) {
      debugPrint('[Splash] Failed to refresh chat pets: $err');
    }
    try {
      await ref.read(nannyProfileProvider.notifier).refreshSilently();
    } catch (err) {
      debugPrint('[Splash] Failed to refresh nanny profile: $err');
    }
    ref.invalidate(loginMethodProvider);
  }

  void _changeSheet(SplashActionSheet next, {int? formTabIndex}) {
    if (_isAnimating || next == _currentSheet) return;

    if (formTabIndex != null && next == SplashActionSheet.signInUp) {
      _signInUpFormTabIndex = formTabIndex;
      _sheetInstances[next] = _sheetBuilders[next]!();
    }

    if (_rebuildAlwaysSheets.contains(next)) {
      _sheetInstances[next] = _sheetBuilders[next]!();
    }

    _isForward = next.index > _currentSheet.index;

    _currentPageOffset =
        Tween<Offset>(
          begin: Offset.zero,
          end: Offset(_isForward ? -1 : 1, 0),
        ).animate(
          CurvedAnimation(parent: _pageController, curve: Curves.easeInOut),
        );

    _nextPageOffset =
        Tween<Offset>(
          begin: Offset(_isForward ? 1 : -1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _pageController, curve: Curves.easeInOut),
        );

    setState(() {
      _nextSheet = next;
      _isAnimating = true;
    });

    _pageController.forward(from: 0).then((_) {
      if (!mounted) return;
      setState(() {
        _currentSheet = _nextSheet;
        _isAnimating = false;
      });
    });
  }

  Widget _buildCurrentSheet() {
    if (!_isAnimating) {
      return _sheetInstances[_currentSheet]!;
    } else {
      return Stack(
        children: [
          SlideTransition(
            position: _currentPageOffset,
            child: _sheetInstances[_currentSheet]!,
          ),
          SlideTransition(
            position: _nextPageOffset,
            child: _sheetInstances[_nextSheet]!,
          ),
        ],
      );
    }
  }

  void _onPhoneLoginSuccess() async {
    final l10n = AppLocalizations.of(context)!;
    TO.show(context, l10n.toastLoginSuccess);
    await _refreshUserAndPets();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  void _onSocialLoginSuccess() async {
    final l10n = AppLocalizations.of(context)!;
    TO.show(context, l10n.toastLinkLoginSuccess);
    await _refreshUserAndPets();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  void _onPhoneRegisterSuccess() async {
    ref.invalidate(phoneRegisterDataProvider);
    final l10n = AppLocalizations.of(context)!;
    TO.show(context, l10n.toastRegisterSuccess);
    await _refreshUserAndPets();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  void _onSocialRegisterSuccess() async {
    ref.invalidate(socialRegisterDataProvider);
    final l10n = AppLocalizations.of(context)!;
    TO.show(context, l10n.toastLinkRegisterSuccess);
    await _refreshUserAndPets();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  void _onChangeForgotPasswordSuccess() {
    ref.invalidate(forgotPasswordDataProvider);
    final l10n = AppLocalizations.of(context)!;
    TO.show(context, l10n.toastChangePasswordSuccess);
    if (!mounted) return;
    _changeSheet(SplashActionSheet.signInUp, formTabIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final topHeight = SC.sh(213);
    final safeTop = SC.physicPaddingTop;

    return AssistantVisibilityScope.hide(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: KeyboardDismisser(
          child: CustomScaffold(
            backgroundColor: AppColors.white,
            body: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(
                    milliseconds: TransitionConfig.durationLong,
                  ),
                  curve: Curves.easeOutCubic,
                  top: _animate ? safeTop : topHeight,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRect(
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/images/splash_screen_doggo.png',
                        width: SizeConfig.physicScreenWidth,
                        fit: BoxFit.fill,
                        alignment: Alignment.topRight,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(
                    milliseconds: TransitionConfig.durationMedium,
                  ),
                  curve: Curves.easeOutCubic,
                  top: _animate ? -topHeight : safeTop,
                  left: 0,
                  right: 0,
                  height: topHeight,
                  child: Center(
                    child: Image.asset(
                      'assets/images/splash_screen_logo.png',
                      width: SizeConfig.sw(240),
                      height: SizeConfig.sh(80),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: _animate ? 0.3 : 0.0,
                    duration: const Duration(
                      milliseconds: TransitionConfig.durationLong,
                    ),
                    curve: Curves.easeOutCubic,
                    child: Container(color: Colors.black),
                  ),
                ),
                SafeAreaTopOnly(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildCurrentSheet(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
