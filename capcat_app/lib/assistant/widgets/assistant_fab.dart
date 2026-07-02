import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssistantFab extends StatelessWidget {
  const AssistantFab({
    super.key,
    required this.onTap,
    this.size,
    this.right,
    this.bottom,
    this.backgroundColor,
    this.iconColor,
    this.icon,
    this.iconAssetPath,
    this.useSafeArea = true,
  });

  final VoidCallback onTap;
  final double? size;
  final double? right;
  final double? bottom;
  final Color? backgroundColor;
  final Color? iconColor;
  final Widget? icon;
  final String? iconAssetPath;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final fabSize = size ?? SC.smin(64);
    final rightInset = right ?? SC.sw(16);
    final bottomInset = bottom ?? SC.sh(16);
    final safeBottom = useSafeArea ? MediaQuery.paddingOf(context).bottom : 0.0;
    final resolvedBg = backgroundColor ?? AC.white;
    final resolvedIconColor = iconColor ?? AC.white;
    final resolvedIconAssetPath = iconAssetPath ?? 'assets/icons/nanny.svg';

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(
          right: rightInset,
          bottom: bottomInset + safeBottom,
        ),
        child: TapEffect(
          onTap: onTap,
          child: Container(
            width: fabSize,
            height: fabSize,
            decoration: BoxDecoration(
              color: resolvedBg,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AC.blackPure.withValues(alpha: 0.18),
                  blurRadius: SC.smin(12),
                  offset: Offset(0, SC.sh(4)),
                ),
              ],
            ),
            child: Center(
              child: _buildIcon(
                icon: icon,
                iconAssetPath: resolvedIconAssetPath,
                iconColor: resolvedIconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildIcon({
  required Widget? icon,
  required String? iconAssetPath,
  required Color iconColor,
}) {
  if (icon != null) return icon;

  if (iconAssetPath != null && iconAssetPath.isNotEmpty) {
    if (iconAssetPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        iconAssetPath,
        width: SC.smin(40),
        height: SC.smin(40),
      );
    }
    return Image.asset(
      iconAssetPath,
      width: SC.smin(24),
      height: SC.smin(24),
      color: iconColor,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.auto_awesome_rounded,
          size: SC.smin(24),
          color: iconColor,
        );
      },
    );
  }

  return Icon(Icons.auto_awesome_rounded, size: SC.smin(24), color: iconColor);
}
