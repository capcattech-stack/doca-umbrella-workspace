import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';

class TagItem<T> {
  final T value;
  final String label;
  final Color selectedBg;
  final Color selectedBorder;
  final Color selectedText;

  const TagItem({
    required this.value,
    required this.label,
    required this.selectedBg,
    required this.selectedBorder,
    required this.selectedText,
  });
}

class TagSelector<T> extends StatelessWidget {
  const TagSelector({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.unselectedBg = AC.greyBox2,
    this.unselectedBorder = AC.greyBox2,
    this.unselectedText = AC.greyText5,
    this.itemHeight,
    this.itemsPerRow = 2,
  });

  final T value;
  final ValueChanged<T> onChanged;
  final List<TagItem<T>> items;
  final Color unselectedBg;
  final Color unselectedBorder;
  final Color unselectedText;
  final double? itemHeight;
  final int itemsPerRow;

  @override
  Widget build(BuildContext context) {
    final screenWidth = SC.physicScreenWidth;
    double hp = SC.sw(24);
    double totalSpacing = SC.sw(16);

    double spacing = totalSpacing / (itemsPerRow - 1);
    double itemWidth = (screenWidth - hp * 2 - totalSpacing) / itemsPerRow;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: items.map((item) {
        final selected = value == item.value;
        return _Tag(
          label: item.label,
          width: itemWidth,
          height: itemHeight ?? SC.sh(44),
          bg: selected ? item.selectedBg : unselectedBg,
          border: selected ? item.selectedBorder : unselectedBorder,
          textColor: selected ? item.selectedText : unselectedText,
          onTap: () => onChanged(item.value),
        );
      }).toList(),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.bg,
    required this.border,
    required this.textColor,
    required this.onTap,
    required this.height,
    required this.width,
  });

  final String label;
  final Color bg, border, textColor;
  final double width, height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color.fromRGBO(12, 26, 75, 0.04), blurRadius: 5),
            BoxShadow(
              color: Color.fromRGBO(50, 50, 71, 0.02),
              offset: Offset(0, 4),
              blurRadius: 20,
              spreadRadius: -2,
            ),
          ],
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: SC.sf(14),
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
