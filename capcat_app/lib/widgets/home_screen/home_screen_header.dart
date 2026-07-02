import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key});

  static const BoxDecoration _headerDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 78 + SizeConfig.physicPaddingTop,
      padding: EdgeInsets.fromLTRB(16, SizeConfig.physicPaddingTop, 16, 16),
      decoration: _headerDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile
          SizedBox(
            height: 46,
            child: Row(
              children: const [
                // Avatar
                CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColors.greenStrong1,
                  child: Center(
                    child: Image(
                      image: AssetImage(
                        'assets/images/icon_profile_splash.png',
                      ),
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Greeting
                SizedBox(
                  height: 23,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hi, Tân Tân!',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        height: 23 / 18,
                        color: AC.blackHeaderDeep,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scan Button
          Image(
            image: const AssetImage('assets/icons/scan.png'),
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
