import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';

class InputField extends StatefulWidget {
  final String hintText;
  final String? iconPath;
  final TextEditingController? controller;
  final String? initialValue;
  // final bool obscureText;
  final TextInputType? keyboardType;
  final bool isLarge;
  final bool isPasswordField;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? borderColor;

  final void Function(String)? onChanged;

  const InputField({
    super.key,
    required this.hintText,
    this.iconPath,
    this.controller,
    this.initialValue,
    // this.obscureText = false,
    this.keyboardType,
    this.isLarge = false,
    this.isPasswordField = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.borderColor,
    this.onChanged,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final TextEditingController _controller;
  late final bool _usingInternalController;
  late bool _isObscuringText;

  @override
  void initState() {
    super.initState();
    _usingInternalController = widget.controller == null;
    _controller =
        widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
    _isObscuringText = widget.isPasswordField == true;
  }

  @override
  void dispose() {
    if (_usingInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLarge = widget.isLarge == true;
    final double iconSize = SC.smin(24);

    return Container(
      width: double.infinity,
      height: isLarge ? null : SizeConfig.sh(56),
      padding: EdgeInsets.fromLTRB(
        SC.sw(20),
        isLarge ? SC.sh(16) : 0,
        SC.sw(20),
        isLarge ? SC.sh(16) : 0,
      ),
      decoration: BoxDecoration(
        color:
            widget.isDisabled ? AC.greyBorder2 : (widget.backgroundColor ?? AC.greyBox1),
        border: Border.all(color: widget.borderColor ?? AC.greyBorder1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (widget.iconPath != null) ...[
            Image.asset(
              widget.iconPath!,
              height: iconSize,
              width: iconSize,
              fit: BoxFit.scaleDown,
            ),
            SizedBox(width: SC.sw(12)),
          ],
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: isLarge
                  ? TextInputType.multiline
                  : widget.keyboardType,
              obscureText: _isObscuringText,
              textAlignVertical: isLarge ? TextAlignVertical.top : null,
              maxLines: isLarge ? null : 1,
              minLines: isLarge ? 5 : 1,
              enabled: !widget.isDisabled,
              readOnly: widget.isDisabled,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
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
                color: AC.blackText1,
              ),
              onChanged: widget.isDisabled ? null : widget.onChanged,
            ),
          ),

          // Icon con mắt nếu là password field
          if (widget.isPasswordField == true) ...[
            SizedBox(width: SC.sw(12)),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isObscuringText = !_isObscuringText;
                });
              },
              child: Icon(
                _isObscuringText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AC.greyText1,
                size: iconSize,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
