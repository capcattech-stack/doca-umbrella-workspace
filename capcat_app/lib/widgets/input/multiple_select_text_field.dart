import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/dialog_utils.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';

typedef OnMultiStringSelected = void Function(List<String> values);

class MultipleSelectTextField extends StatefulWidget {
  final List<String> fullOptions;
  final List<String> quickOptions;
  final String hintText;
  final String sheetTitle;
  final String searchHint;
  final String allSectionText;
  final OnMultiStringSelected? onChanged;
  final Widget? icon;
  final List<String> initialSelected;
  final int? maxSelection;

  const MultipleSelectTextField({
    super.key,
    required this.fullOptions,
    this.quickOptions = const [],
    required this.hintText,
    required this.sheetTitle,
    this.searchHint = 'Tìm',
    required this.allSectionText,
    this.onChanged,
    this.icon,
    this.initialSelected = const [],
    this.maxSelection,
  });

  @override
  State<MultipleSelectTextField> createState() =>
      _MultipleSelectTextFieldState();
}

class _MultipleSelectTextFieldState extends State<MultipleSelectTextField> {
  late List<String> _selected;

  List<String> _limitSelection(List<String> values) {
    if (widget.maxSelection == null) return values;
    if (values.length <= widget.maxSelection!) return values;
    return values.take(widget.maxSelection!).toList();
  }

  @override
  void initState() {
    super.initState();
    _selected = _limitSelection(List.from(widget.initialSelected));
  }

  Future<void> _openPicker() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (ctx) {
        return _MultiTextPickerSheet(
          title: widget.sheetTitle,
          options: widget.fullOptions,
          initialSelected: _selected,
          maxSelection: widget.maxSelection,
        );
      },
    );

    if (!mounted) return;
    if (result != null) {
      final limited = _limitSelection(result);
      setState(() {
        _selected = limited;
      });
      widget.onChanged?.call(_selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _selected.isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (!hasValue) _openPicker();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          SC.sw(20),
          SC.sh(20),
          SC.sw(20),
          SC.sh(20),
        ),
        decoration: BoxDecoration(
          color: AC.greyBox1,
          border: Border.all(color: AC.greyBorder1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: hasValue
            ? Wrap(
                spacing: SC.sw(10),
                runSpacing: SC.sw(10),
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ..._selected.map((e) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SC.sw(16),
                        vertical: SC.sh(8),
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(203, 243, 229, 0.5),
                        border: Border.all(
                          color: AC.greenStrong2,
                          width: SC.smin(2),
                        ),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(12, 26, 75, 0.04),
                            blurRadius: SC.smin(5),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(50, 50, 71, 0.02),
                            offset: Offset(0, 4),
                            blurRadius: SC.smin(20),
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: Text(
                        e,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w500,
                          fontSize: SC.sf(14),
                          color: AC.greenStrong2,
                        ),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: _openPicker,
                    child: Container(
                      width: SC.sw(36),
                      height: SC.sh(36),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: SC.smin(16),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.hintText,
                    style: TextStyle(
                      fontSize: SC.sf(14),
                      color: AC.greyText1,
                    ),
                  ),
                  if (widget.icon != null) widget.icon!,
                ],
              ),
      ),
    );
  }
}

class _MultiTextPickerSheet extends StatefulWidget {
  const _MultiTextPickerSheet({
    required this.title,
    required this.options,
    required this.initialSelected,
    this.maxSelection,
  });

  final String title;
  final List<String> options;
  final List<String> initialSelected;
  final int? maxSelection;

  @override
  State<_MultiTextPickerSheet> createState() => _MultiTextPickerSheetState();
}

class _MultiTextPickerSheetState extends State<_MultiTextPickerSheet> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
  }

  void _toggle(String value) {
    final max = widget.maxSelection;

    if (_selected.contains(value)) {
      setState(() => _selected.remove(value));
      return;
    }

    if (max != null && _selected.length >= max) {
      // TO.show(
      //   context,
      //   'Bạn chỉ có thể chọn tối đa $max sở thích cho bé',
      // );
      ToastOverlay.show(context, 'Bạn chỉ được chọn tối đa 3 sở thích!');
      return;
    }

    setState(() => _selected.add(value));
  }

  @override
  Widget build(BuildContext context) {
    final max = widget.maxSelection;
    final counter = max == null ? '' : ' ${_selected.length}/$max';

    return Container(
      width: double.infinity,
      height: SC.sh(442) + MQ.bottomPadding(context),
      decoration: BoxDecoration(
        color: AC.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(12, 26, 75, 0.1), blurRadius: 8),
          BoxShadow(
            color: Color.fromRGBO(50, 50, 71, 0.02),
            offset: Offset(0, 4),
            blurRadius: 20,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: SC.sh(12)),
          Container(
            width: SC.sw(80),
            height: SC.sh(5),
            decoration: BoxDecoration(
              color: AC.greyText6,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          SizedBox(height: SC.sh(12)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SC.sw(24)),
            child: SizedBox(
              height: SC.sh(27),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.title + counter,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: SC.sf(16),
                          color: AC.neutralChipText,
                        ),
                      ),
                    ),
                  ),
                  TapEffect(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: AC.slateIconStrong),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: SC.sh(16)),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: SC.sw(24)),
              child: Wrap(
                spacing: SC.sw(8),
                runSpacing: SC.sw(12),
                children: widget.options.map((opt) {
                  final isSelected = _selected.contains(opt);
                  return GestureDetector(
                    onTap: () => _toggle(opt),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SC.sw(16),
                        vertical: SC.sh(8),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromRGBO(203, 243, 229, 0.5)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? AC.greenStrong2
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(12, 26, 75, 0.04),
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(50, 50, 71, 0.02),
                            offset: Offset(0, 4),
                            blurRadius: 20,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: Text(
                        opt,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w500,
                          fontSize: SC.sf(14),
                          color: isSelected
                              ? AC.greenStrong2
                              : AC.neutralPrimaryText,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: SC.sh(24)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SC.sw(24)),
            child: ActionButton(
              text: 'Lưu lại',
              trailingIcon: Image.asset('assets/icons/ab-check.png'),
              onTap: () => Navigator.of(context).pop(_selected),
            ),
          ),

          SizedBox(height: MQ.bottomPadding(context)),
        ],
      ),
    );
  }
}
