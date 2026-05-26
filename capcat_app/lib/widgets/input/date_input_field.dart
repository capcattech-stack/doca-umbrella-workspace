import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class DateInputField extends StatefulWidget {
  const DateInputField({
    super.key,
    required this.hintText,
    this.controller, // optional, not used here - internal controller is fine
    this.icon,
    this.initialDate,
    this.onChanged,
    this.firstDate,
    this.lastDate,
  });

  final String hintText;
  final TextEditingController? controller;
  final IconData? icon;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onChanged;

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  late final TextEditingController _controller;
  DateTime? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialDate;
    _controller =
        widget.controller ?? TextEditingController(text: _format(_value));
  }

  @override
  void didUpdateWidget(covariant DateInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialDate != oldWidget.initialDate) {
      _value = widget.initialDate;
      _controller.text = _format(_value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _two(int v) => v.toString().padLeft(2, '0');

  String _format(DateTime? d) {
    if (d == null) return '';
    return '${_two(d.day)}/${_two(d.month)}/${d.year}';
  }

  Future<void> _handleTap() async {
    final now = DateTime.now();
    final initial = _value ?? widget.initialDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? now,
      // locale: const Locale('vi'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AC.greenStrong2, // màu chính (AppBar, nút chọn)
              onPrimary: AC.white, // màu chữ trên nền primary
              surface: AC.white, // nền chính
              onSurface: AC.blackText4, // màu chữ, số ngày
            ),
            dialogBackgroundColor: AC.white, // nền popup
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    AC.greenStrong2, // màu chữ của nút “HỦY” và “OK”
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: AC.white,
              headerBackgroundColor: AC.greenStrong2,
              headerForegroundColor: AC.white,
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AC.white;
                }
                return AC.blackText4;
              }),
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AC.greenStrong2;
                }
                return null;
              }),
              //todayForegroundColor: MaterialStateProperty.all(AC.greenStrong2),
              rangePickerHeaderForegroundColor: AC.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return; // user cancelled

    setState(() {
      _value = picked;
      _controller.text = _format(_value);
    });
    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _handleTap,
      child: Container(
        width: double.infinity,
        height: SizeConfig.sh(56),
        padding: EdgeInsets.fromLTRB(SC.sw(20), 0, SC.sw(20), 0),
        decoration: BoxDecoration(
          color: AC.greyBox1,
          border: Border.all(color: AC.greyBorder1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: AC.greyText3, size: 24),
              SizedBox(width: SizeConfig.sw(12)),
            ],
            Expanded(
              child: IgnorePointer(
                child: TextField(
                  controller: _controller,
                  readOnly: true,
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
                    fontWeight: FontWeight.w500,
                    color: AC.blackText4,
                  ),
                  enableInteractiveSelection: false,
                  showCursor: false,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: SizeConfig.sw(12)),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: AC.greyText3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
