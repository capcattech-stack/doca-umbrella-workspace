import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capcat_doca/screens/entry/app_entry_point.dart';
import 'package:capcat_doca/utils/global_keys.dart';
import 'package:capcat_doca/utils/route_observer.dart';
import 'package:capcat_doca/widgets/no_internet_modal_widget.dart';
import 'package:capcat_doca/widgets/loading_overlay_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/providers/locale_provider.dart';
import 'package:capcat_doca/assistant/assistant_host.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  // Default: non-edge-to-edge, light nav bar (single init-time call).
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: AC.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AC.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
      child: MaterialApp(
        showPerformanceOverlay: false,
        debugShowCheckedModeBanner: false,
        navigatorKey: rootNavigatorKey,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.white,
          fontFamily: 'Quicksand',
          useMaterial3: true,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: AC.blackText1, // màu con trỏ
            selectionColor: AC.greyLine1, // màu nền khi bôi chọn text
            selectionHandleColor: AC.blackText1, // nút kéo chọn
          ),
        ),

        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        navigatorObservers: [routeObserver],

        builder: (context, child) => Stack(
          children: [
            AssistantHost(child: child ?? const SizedBox.shrink()),
            const NoInternetModalWidget(),
            const LoadingOverlayWidget(),
          ],
        ),
        home: const AppEntryPoint(),
      ),
    );
  }
}
