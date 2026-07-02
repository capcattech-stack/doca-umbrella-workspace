import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';

class CustomAppHeader extends StatelessWidget {
  const CustomAppHeader({
    super.key,
    required this.title,
    this.body,
    this.subtitle,
    this.hasLeftAction = true,
    this.leftActionIcon,
    this.onTapLeftAction,
    this.color,
    this.leftActionSeperatorColor,
    this.showBottomLine = true,
    this.subtitleWidget,
  });

  final String title;
  final String? subtitle;
  final Widget? body;
  final bool hasLeftAction;
  final String? leftActionIcon;
  final VoidCallback? onTapLeftAction;
  final Color? color;
  final Color? leftActionSeperatorColor;
  final bool showBottomLine;
  final Widget? subtitleWidget;

  @override
  Widget build(BuildContext context) {
    final double hp = SC.sw(24);
    //--Column (Header, Bottom Line)
    return Column(
      children: [
        //--Header
        Container(
          width: double.infinity,
          height: SC.sh(66),
          color: color ?? AppColors.background,
          padding: EdgeInsets.fromLTRB(hp, 0, hp, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //--Left Action Group
              SizedBox(
                width: SC.sw(20 + 8 + 1 + 8),
                child: hasLeftAction
                    ? Row(
                        children: [
                          TapEffect(
                            onTap:
                                onTapLeftAction ??
                                () => Navigator.of(context).pop(),
                            child: SizedBox(
                              width: SC.sw(20),
                              child: hasLeftAction
                                  ? Image.asset(
                                      leftActionIcon != null
                                          ? leftActionIcon!
                                          : 'assets/icons/main-back.png',
                                      fit: BoxFit.scaleDown,
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(width: SC.sw(8)),
                          Container(
                            width: SC.sw(1),
                            height: SC.sh(30),
                            color: leftActionSeperatorColor ?? AC.greyLine2,
                          ),
                          SizedBox(width: SC.sw(8)),
                        ],
                      )
                    : null,
              ),

              //--Text Group
              Expanded(
                child: SizedBox(
                  child: Align(
                    alignment: Alignment.center,
                    child: body ??
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //--Title
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600,
                                fontSize: SC.sf(16),
                                height: 22 / 16,
                                color: AC.blackText5,
                              ),
                            ),
                            //--Subtitle
                            if (subtitleWidget != null)
                              subtitleWidget!
                            else if (subtitle != null)
                              Text(
                                subtitle!,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w500,
                                  fontSize: SC.sf(14),
                                  height: 20 / 14,
                                  color: AC.greyText5,
                                ),
                              ),
                          ],
                        ),
                  ),
                ),
              ),
              //--Right Action Group
              SizedBox(width: SC.sw(20 + 8 + 1 + 8)),
            ],
          ),
        ),

        //--Bottom Line
        if (showBottomLine == true)
          Container(
            width: SC.physicScreenWidth - hp * 2,
            height: SC.sh(1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AC.greyLine1.withAlpha(26),
                  AC.greyLine1.withAlpha(77),
                  AC.greyLine1.withAlpha(26),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
      ],
    );
  }
}
