import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/enums/splash_action_sheet.dart';
import 'package:capcat_doca/screens/main/main_screen.dart';
import 'package:capcat_doca/screens/splash/splash_screen_with_animation_controller.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/app_preferences.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  late final Future<({bool hasValidSession, bool hasSeenIntro})> _initFuture;

  Future<({bool hasValidSession, bool hasSeenIntro})> _init() async {
    bool hasValidSession = false;
    bool hasSeenIntro = false;

    try {
      hasValidSession = await AuthService.hasValidBootstrapSession().timeout(
        const Duration(seconds: 3),
      );
    } catch (e, st) {
      debugPrint('[AppEntryPoint] Failed to validate bootstrap session: $e');
      debugPrintStack(stackTrace: st);
    }

    try {
      hasSeenIntro = await AppPreferences.hasSeenIntro().timeout(
        const Duration(seconds: 3),
      );
    } catch (e, st) {
      debugPrint('[AppEntryPoint] Failed to read intro flag: $e');
      debugPrintStack(stackTrace: st);
    }

    return (hasValidSession: hasValidSession, hasSeenIntro: hasSeenIntro);
  }

  @override
  void initState() {
    super.initState();
    _initFuture = _init();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return AssistantVisibilityScope.hide(
      child: Stack(
        children: [
          FutureBuilder<({bool hasValidSession, bool hasSeenIntro})>(
            future: _initFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const _BootstrapBackground();
              }

              final result =
                  snapshot.data ??
                  (hasValidSession: false, hasSeenIntro: false);
              final hasValidSession = result.hasValidSession;

              if (hasValidSession) {
                return const MainScreen();
              }

              // Intro is currently disabled intentionally.
              // To re-enable: branch on result.hasSeenIntro here.

              return const SplashScreenWithAnimationController(
                initialSheet: SplashActionSheet.signInUp,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BootstrapBackground extends StatelessWidget {
  const _BootstrapBackground();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned.fill(
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
        ],
      ),
    );
  }
}
