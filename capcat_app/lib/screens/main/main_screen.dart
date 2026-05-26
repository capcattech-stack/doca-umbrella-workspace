import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/providers/main_navigation_provider.dart';
import 'package:flutter_chat_mock_app/screens/main/chat/chat_landing_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/home/home_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/moments/emotion_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/my_pets_screen.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/transition_config.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile/profile_screen.dart';
import 'package:flutter_chat_mock_app/widgets/main_bottom_navigation_bar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final List<Widget> _screens = const [
    // EmotionScreen(),
    HomeScreen(),
    MyPetsScreen(),
    ChatLandingScreen(),
    // PetProfileScreen(),
    // NewsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(mainNavigationIndexProvider);
    return Stack(
      children: [
        CustomScaffold(
          backgroundColor: AppColors.white,
          body: SafeAreaTopOnly(
            child: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: TransitionConfig.durationShort,
              ),
              // child: Expanded(
              child: KeyedSubtree(
                key: ValueKey(selectedIndex),
                child: _screens[selectedIndex],
              ),
              // )
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
        ),
        Positioned(
          bottom: MQ.bottomPadding(context) + SC.sh(16),
          // bottom: 0,
          // + SC.phyBotBarVp,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: MainBottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                ref.read(mainNavigationIndexProvider.notifier).state = index;
              },
            ),
          ),
        ),
        // const LoadingOverlayWidget(),
      ],
    );
  }
}
