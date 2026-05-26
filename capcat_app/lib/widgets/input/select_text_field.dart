// file: select_text_field.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';

typedef OnStringSelected = void Function(String? value);

class SelectTextField extends StatefulWidget {
  final TextEditingController? controller;
  final List<String> fullOptions;
  final List<String> quickOptions;
  final String hintText;
  final String sheetTitle;
  final String searchHint;
  final String allSectionText;
  final OnStringSelected? onChanged;
  final IconData? icon;
  final bool readOnly;
  final bool isMiniVersion;

  const SelectTextField({
    super.key,
    this.controller,
    required this.fullOptions,
    this.quickOptions = const [],
    required this.hintText,
    required this.sheetTitle,
    this.searchHint = 'Tìm',
    required this.allSectionText,
    this.onChanged,
    this.icon,
    this.readOnly = true,
    this.isMiniVersion = false,
  });

  @override
  State<SelectTextField> createState() => _SelectTextFieldState();
}

class _SelectTextFieldState extends State<SelectTextField> {
  late TextEditingController _controller;
  late bool _usingInternalController;
  String? _selected;
  VoidCallback? _controllerListener;

  @override
  void initState() {
    super.initState();
    _usingInternalController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _selected = _controller.text.isNotEmpty ? _controller.text : null;

    _controllerListener = () {
      final text = _controller.text;
      final newSelected = text.isNotEmpty ? text : null;
      if (newSelected != _selected) {
        setState(() {
          _selected = newSelected;
        });
      }
    };

    _controller.addListener(_controllerListener!);
  }

  @override
  void didUpdateWidget(covariant SelectTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_controllerListener!);
      if (_usingInternalController) {
        _controller.dispose();
      }

      _usingInternalController = widget.controller == null;
      _controller = widget.controller ?? TextEditingController();

      _selected = _controller.text.isNotEmpty ? _controller.text : null;
      _controller.addListener(_controllerListener!);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener!);
    if (_usingInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _openPicker() async {
    // Chuyển focus sang một FocusNode tạm để tránh trả lại focus cho ô nhập trước đó
    FocusScope.of(context).requestFocus(FocusNode());

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (ctx) {
        return _TextPickerSheet(
          title: widget.sheetTitle,
          options: widget.fullOptions,
          quickPicks: widget.isMiniVersion ? const [] : widget.quickOptions,
          searchHint: widget.searchHint,
          allSectionText: widget.isMiniVersion ? '' : widget.allSectionText,
          currentSelected: _selected,
          isMiniVersion: widget.isMiniVersion,
        );
      },
      useSafeArea: true,
    );

    if (!mounted) return;

    // Giữ nguyên giá trị cũ nếu user đóng sheet (selected == null)
    if (selected != null) {
      _controller.text = selected;
      widget.onChanged?.call(selected);
    }

    // Đảm bảo không trả focus về bất kỳ ô nhập nào sau khi đóng sheet.
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = (_selected?.isNotEmpty ?? false);

    return TapEffect(
      // behavior: HitTestBehavior.opaque,
      onTap: widget.readOnly ? _openPicker : null,
      child: Container(
        width: double.infinity,
        height: SizeConfig.sh(56),
        padding: EdgeInsets.fromLTRB(
          SizeConfig.sw(20),
          0,
          SizeConfig.sw(20),
          0,
        ),
        decoration: BoxDecoration(
          color: AC.greyBox1,
          border: Border.all(color: AC.greyBorder1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: AC.greyText3,
                size: SC.smin(24),
              ),
              SizedBox(width: SizeConfig.sw(12)),
            ],
            Expanded(
              child: AbsorbPointer(
                absorbing: widget.readOnly,
                child: TextField(
                  controller: _controller,
                  readOnly: widget.readOnly,
                  decoration: InputDecoration(
                    fillColor: AC.greyBox1,
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      fontSize: SizeConfig.sf(14),
                      fontWeight: FontWeight.w400,
                      color: AC.greyText1,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: SizeConfig.sf(14),
                    color: hasValue
                        ? AC.blackText4
                        : AC.greyText1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: SizeConfig.sw(8)),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AC.greyText3,
            ),
          ],
        ),
      ),
    );
  }
}

//--Bottom Sheet (single select) có nút X và highlight item đang chọn
class _TextPickerSheet extends StatefulWidget {
  const _TextPickerSheet({
    required this.title,
    required this.options,
    required this.quickPicks,
    required this.searchHint,
    required this.allSectionText,
    this.currentSelected,
    required this.isMiniVersion,
  });

  final String title;
  final List<String> options;
  final List<String> quickPicks;
  final String searchHint;
  final String allSectionText;
  final String? currentSelected;
  final bool isMiniVersion;

  @override
  State<_TextPickerSheet> createState() => _TextPickerSheetState();
}

class _TextPickerSheetState extends State<_TextPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.options;
    if (!widget.isMiniVersion) {
      _searchController.addListener(_onSearch);
    }
  }

  @override
  void dispose() {
    if (!widget.isMiniVersion) {
      _searchController.removeListener(_onSearch);
    }
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    if (widget.isMiniVersion) return;
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.options
          : widget.options.where((e) => e.toLowerCase().contains(q)).toList();
    });
  }

  Widget _buildOptionsList({ScrollPhysics? physics, bool shrinkWrap = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          physics: physics,
          shrinkWrap: shrinkWrap,
          itemCount: _filtered.length,
          separatorBuilder: (_, __) => SizedBox(height: SC.sh(8)),
          itemBuilder: (_, i) {
            final text = _filtered[i];
            final bool isSelected = text == widget.currentSelected;
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.of(context).pop(text),
              child: Ink(
                height: SC.sh(44),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromRGBO(203, 243, 229, 0.5)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(
                          color: AC.greenStrong2,
                          width: SC.smin(2),
                        )
                      : null,
                ),
                child: SizedBox.expand(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SC.sw(16)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _ListItemText(text),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (widget.isMiniVersion) {
      return _buildMiniSheet(media);
    }
    return _buildStandardSheet(media);
  }

  Widget _buildStandardSheet(MediaQueryData media) {
    final maxHeight = media.size.height * 0.90; // almost full
    // const double contentWidth = 327.0;
    const double contentWidth = double.infinity;

    return SafeAreaTopOnly(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            maxWidth: media.size.width,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AC.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
              ),
              // boxShadow: const [
              //   BoxShadow(
              //     color: Color.fromRGBO(12, 26, 75, 0.1),
              //     blurRadius: 8,
              //   ),
              //   BoxShadow(
              //     color: Color.fromRGBO(50, 50, 71, 0.02),
              //     offset: Offset(0, 4),
              //     blurRadius: 20,
              //     spreadRadius: -2,
              //   ),
              // ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: contentWidth),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: SC.sh(27),
                              child: Row(
                                children: [
                                  SizedBox(width: SC.sw(24)),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        widget.title,
                                        style: TextStyle(
                                          fontFamily: 'Noto Sans',
                                          fontWeight: FontWeight.w600,
                                          fontSize: SC.sf(16),
                                          height: 22 / 16,
                                          color: AC.blackText5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    splashRadius: SC.smin(20),
                                    padding: const EdgeInsets.all(0),
                                    icon: const Icon(
                                      Icons.close,
                                      color: AC.slateIconStrong,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: SC.sh(12)),
                            SizedBox(
                              height: SC.sh(40),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: SC.sw(16),
                                    vertical: SC.sh(12),
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(
                                      left: SC.sw(8),
                                      right: SC.sw(4),
                                    ),
                                    child: Icon(
                                      Icons.search_rounded,
                                      size: SC.smin(20),
                                      color: AC.slateInputIcon,
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: SC.sw(36),
                                    minHeight: SC.sh(20),
                                  ),
                                  hintText: widget.searchHint,
                                  hintStyle: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w500,
                                    fontSize: SC.sf(14),
                                    height: 18 / 14,
                                    color: AC.slateInputIcon,
                                  ),
                                  filled: true,
                                  fillColor: AC.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: AC.slateIntroStroke,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                      color: AC.slateIntroStroke,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: SC.sh(16)),
                            if (widget.quickPicks.isNotEmpty) ...[
                              Text(
                                'Lựa chọn gần đây',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w500,
                                  fontSize: SC.sf(12),
                                  height: 20 / 12,
                                  color: AC.greyText3,
                                ),
                              ),
                              SizedBox(height: SC.sh(8)),
                              Wrap(
                                spacing: SC.smin(10),
                                runSpacing: SC.smin(10),
                                children: widget.quickPicks.map((label) {
                                  return GestureDetector(
                                    onTap: () =>
                                        Navigator.of(context).pop(label),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: SC.sw(14),
                                        vertical: SC.sh(4),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontWeight: FontWeight.w500,
                                          fontSize: SC.sf(14),
                                          height: 20 / 14,
                                          color: AC.neutralPrimaryText,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: SC.sh(16)),
                            ],
                            if (widget.allSectionText.isNotEmpty) ...[
                              Text(
                                widget.allSectionText,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.sf(12),
                                  height: 20 / 12,
                                  color: AC.greyText3,
                                ),
                              ),
                              SizedBox(height: SizeConfig.sh(8)),
                            ],
                            Expanded(child: _buildOptionsList()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MQ.bottomPadding(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniSheet(MediaQueryData media) {
    double horizontalPadding = SC.sw(24);
    double itemHeight = SC.sh(44);
    double itemSpacing = SC.sh(8);
    double minListHeight = SC.sh(44);
    final int itemCount = _filtered.length;
    final double rawListHeight = itemCount == 0
        ? minListHeight
        : (itemHeight * itemCount) + (itemSpacing * (itemCount - 1));
    final double maxListHeight = media.size.height * 0.4;
    final double effectiveListHeight = math.max(
      minListHeight,
      math.min(rawListHeight, maxListHeight),
    );
    final bool enableScroll = rawListHeight > effectiveListHeight;

    return SafeAreaTopOnly(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: media.size.height * 0.7,
            maxWidth: media.size.width,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AC.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
              ),
              // boxShadow: const [
              //   BoxShadow(
              //     color: Color.fromRGBO(12, 26, 75, 0.1),
              //     blurRadius: 8,
              //   ),
              //   BoxShadow(
              //     color: Color.fromRGBO(50, 50, 71, 0.02),
              //     offset: Offset(0, 4),
              //     blurRadius: 20,
              //     spreadRadius: -2,
              //   ),
              // ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: SC.sh(27),
                        child: Row(
                          children: [
                            SizedBox(width: SC.sw(24)),
                            Expanded(
                              child: Center(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    // fontFamily: 'Noto Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: SC.sf(16),
                                    height: 22 / 16,
                                    color: AC.blackText5,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              splashRadius: SC.smin(20),
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(
                                Icons.close,
                                color: AC.slateIconStrong,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SC.sh(16)),
                      SizedBox(
                        height: effectiveListHeight,
                        child: _buildOptionsList(
                          physics: enableScroll
                              ? const BouncingScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          shrinkWrap: !enableScroll,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MQ.bottomPadding(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListItemText extends StatelessWidget {
  const _ListItemText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w500,
        fontSize: SC.sf(14),
        height: 20 / 14,
        color: AC.neutralPrimaryText,
      ),
    );
  }
}
