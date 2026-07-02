import 'package:flutter/material.dart';
import 'package:capcat_doca/enums/splash_action_sheet.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/transition_config.dart';
import 'package:capcat_doca/widgets/sign_in_form.dart';
import 'package:capcat_doca/widgets/sign_up_form.dart';
import 'package:capcat_doca/widgets/splash_base_sheet.dart';
import '../../../widgets/tab_selector.dart';

class SignInUpSheet extends StatefulWidget {
  final void Function()? onPhoneLoginSuccess;
  final void Function()? onSocialLoginSuccess;
  final void Function(SplashActionSheet next, {int? formTabIndex}) changeSheet;
  final int initialFormTabIndex;

  const SignInUpSheet({
    super.key,
    required this.changeSheet,
    this.initialFormTabIndex = 0,
    this.onPhoneLoginSuccess,
    this.onSocialLoginSuccess,
  });

  @override
  State<SignInUpSheet> createState() => _SignInUpSheetState();
}

class _SignInUpSheetState extends State<SignInUpSheet> {
  late int _selectedTabIndex;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialFormTabIndex;
    _pageController = PageController(initialPage: _selectedTabIndex);
  }

  void _onSocialLoginNotFound() {
    widget.changeSheet(SplashActionSheet.socialRegisterEnterPhone);
  }

  @override
  Widget build(BuildContext context) {
    final sheetContent = SizedBox(
      width: SC.physicScreenWidth,
      height: SizeConfig.sh(505),
      child: Column(
        children: [
          TabSelector(
            selectedIndex: _selectedTabIndex,
            onTabChanged: (index) {
              setState(() => _selectedTabIndex = index);
              _pageController.animateToPage(
                index,
                duration: const Duration(
                  milliseconds: TransitionConfig.durationShort,
                ),
                curve: Curves.easeInOut,
              );
            },
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                return RepaintBoundary(
                  child: index == 0
                      ? SignInForm(
                          onPhoneLoginSuccess: widget.onPhoneLoginSuccess,
                          onSocialLoginSuccess: widget.onSocialLoginSuccess,
                          onSocialLoginNotFound: _onSocialLoginNotFound,
                          changeSheet: widget.changeSheet,
                        )
                      : SignUpForm(changeSheet: widget.changeSheet),
                );
              },
            ),
          ),
        ],
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
