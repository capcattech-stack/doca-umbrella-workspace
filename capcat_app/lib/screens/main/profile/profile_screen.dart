import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/social_login_platform.dart';
import 'package:flutter_chat_mock_app/providers/login_method_provider.dart';
import 'package:flutter_chat_mock_app/providers/main_navigation_provider.dart';
import 'package:flutter_chat_mock_app/providers/user_detail_provider.dart';
import 'package:flutter_chat_mock_app/screens/main/profile/sub_screens/change_password_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/profile/sub_screens/profile_info_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/profile/sub_screens/terms_of_use_screen.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/auth_util.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_chat_mock_app/widgets/shared/avatar_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  // Future<void> _logout() async {
  //   debugPrint('➡️ Logout tapped');
  //   ref.invalidate(phoneLoginDataProvider);
  //   ref.invalidate(phoneRegisterDataProvider);
  //   ref.invalidate(socialRegisterDataProvider);
  //   ref.invalidate(forgotPasswordDataProvider);
  //   await AuthService.logoutAll();
  //   if (!mounted) return;
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (_) => const AppEntryPoint()),
  //     (route) => false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final double hp = SC.sw(24);
    final double vpL = SC.sh(24);

    // 1) Watch provider dạng AsyncValue
    final userAsync = ref.watch(userDetailProvider);
    final l10n = AppLocalizations.of(context)!;

    return userAsync.when(
      // 2) Trạng thái đang tải (lần đầu app mở / chưa có cache)
      loading: () => const CustomScaffold(
        body: Center(child: CircularProgressIndicator(color: AC.greenStrong1)),
      ),

      // 3) Trạng thái lỗi (refresh nền lỗi, hoặc /me lỗi)
      error: (e, st) => CustomScaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(SC.sw(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.profileLoadError),
                SizedBox(height: SC.sh(8)),
                TapEffect(
                  onTap: () => ref.read(userDetailProvider.notifier).refresh(),
                  child: Text(
                    l10n.profileRetry,
                    style: TextStyle(
                      color: AppColors.greenStrong1,
                      fontSize: SC.sf(14),
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // 4) Có dữ liệu (có thể vẫn là null nếu chưa từng có cache)
      data: (user) {
        // Nếu lần đầu chưa có cache và refresh nền đang chạy -> show skeleton
        if (user == null) {
          return const CustomScaffold(
            body: Center(
              child: CircularProgressIndicator(color: AC.greenStrong1),
            ),
          );
        }

        final displayName = (user.fullName?.trim().isNotEmpty == true)
            ? user.fullName!
            : user.phoneNumber;

        return CustomScaffold(
          backgroundColor: AppColors.white,

          body: SafeAreaTopOnly(
            child: Center(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(hp, vpL, hp, vpL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: SizedBox(
                    //     width: SC.sw(160),
                    //     child: TabSelector(
                    //       selectedIndex: ref.watch(localeProvider).languageCode == 'en' ? 0 : 1,
                    //       width: SC.sw(160),
                    //       labels: const ['ENG', 'VIE'],
                    //       onTabChanged: (index) {
                    //         if (index == 0) {
                    //           ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                    //         } else {
                    //           ref.read(localeProvider.notifier).setLocale(const Locale('vi'));
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: SC.sh(12)),
                    _ProfilePictureGroup(
                      avatarUrl: user.avatarUrl,
                      name: displayName,
                    ),
                    SizedBox(height: SC.sh(38)),
                    _ProfileActionMenu(l10n: l10n),
                    SizedBox(height: SC.sh(38)),
                    _LogoutButton(
                      onTap: () async => await AuthUtil.performLogout(
                        context: context,
                        ref: ref,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfilePictureGroup extends StatelessWidget {
  const _ProfilePictureGroup({this.avatarUrl, required this.name});
  final String? avatarUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SC.sh(116),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //--Avatar
          AvatarWidget(
            imageUrl: avatarUrl,
            isPet: false,
            // editIconPath: 'assets/icons/edit-avatar.png',
          ),
          SizedBox(height: SC.sh(8)),
          // Text section
          SizedBox(
            // width: 74,
            height: SC.sh(28),
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                  fontSize: SC.sf(20),
                  // height: 28 / 20,
                  color: AC.blackText1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionMenu extends ConsumerWidget {
  const _ProfileActionMenu({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginMethodAsync = ref.watch(loginMethodProvider);
    final isGoogleLogin =
        loginMethodAsync.asData?.value == SocialPlatform.google.value;
    final gap = SC.sh(16);

    final settings = <Widget>[
      SettingItem(
        title: l10n.profileMenuAccountInfo,
        leadingIcon: 'assets/icons/profile-info.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UserProfileInfoScreen()),
          );
        },
      ),
      SizedBox(height: gap),
      SettingItem(
        title: l10n.profileMenuMyPets,
        leadingIcon: 'assets/icons/profile-my-pets.png',
        onTap: () {
          ref.read(mainNavigationIndexProvider.notifier).state = 1;
        },
      ),
    ];

    if (!isGoogleLogin) {
      settings
        ..add(SizedBox(height: gap))
        ..add(
          SettingItem(
            title: l10n.profileMenuChangePassword,
            leadingIcon: 'assets/icons/profile-password.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
              );
            },
          ),
        );
    }

    settings
      ..add(SizedBox(height: gap))
      ..add(
        SettingItem(
          title: l10n.profileMenuTerms,
          leadingIcon: 'assets/icons/profile-terms.png',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TermsOfUseScreen()),
            );
          },
        ),
      );

    return Column(children: settings);
  }
}

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.onTap,
  });

  final String title;
  final String leadingIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double width = double.infinity;
    final double height = SC.sh(64);
    return TapEffect(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AC.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(206, 206, 206, 0.10),
              offset: Offset(0, -10),
              blurRadius: 32,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    leadingIcon,
                    width: SC.smin(40),
                    height: SC.smin(40),
                  ),
                  SizedBox(width: SC.sw(10)),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w500,
                      fontSize: SC.sf(14),
                      // height: 24 / 14,
                      letterSpacing: 0.2,
                      color: AC.blackPanelText,
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/icons/arrow-right.png',
                width: SC.smin(16),
                height: SC.smin(16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      // height: SC.sh(44),
      // child: Padding(
      //   padding: EdgeInsets.fromLTRB(
      //     SC.sw(10),
      //     SC.sh(10),
      //     SC.sw(10),
      //     SC.sh(10),
      //   ),
      child: TapEffect(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/dang-xuat.png',
              width: SC.smin(20),
              height: SC.smin(20),
            ),
            SizedBox(width: SC.sw(7)),
            // Text "Đăng xuất"
            Text(
              l10n.profileLogout,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: SC.sf(14),
                // height: 24 / 14,
                letterSpacing: 0.2,
                color: AC.redProfileAction,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
