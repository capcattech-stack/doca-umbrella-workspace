// 📄 tab_selector.dart
import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/utils/transition_config.dart';

class TabSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final List<String>? labels;
  final double? width;

  const TabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    this.labels,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tabCount = 2;
    final totalWidth = width ?? SizeConfig.sw(327);
    final tabWidth = (totalWidth - SizeConfig.sh(8)) / tabCount;
    final resolvedLabels = (labels != null && labels!.length == 2)
        ? labels!
        : [
                      l10n.tabLogin,
                      l10n.tabRegister,
          ];

    return Container(
      width: totalWidth,
      height: SizeConfig.sh(48),
      decoration: BoxDecoration(
        color: AC.greyTab1,
        borderRadius: BorderRadius.circular(SizeConfig.sh(48)),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: selectedIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: const Duration(
              milliseconds: TransitionConfig.durationShort,
            ),
            curve: Curves.easeInOut,
            child: Container(
              width: tabWidth,
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.sh(4)),
              height: SizeConfig.sh(40),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(SizeConfig.sh(32)),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: SizeConfig.sw(8)),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(0),
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildTabItem(
                      resolvedLabels[0],
                      selected: selectedIndex == 0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(1),
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildTabItem(
                      resolvedLabels[1],
                      selected: selectedIndex == 1,
                    ),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.sw(8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String text, {bool selected = false}) {
    return Container(
      height: SizeConfig.sh(40),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          fontSize: SizeConfig.sf(16),
          color: selected ? AC.blackText3 : AC.greyText3,
        ),
      ),
    );
  }
}
