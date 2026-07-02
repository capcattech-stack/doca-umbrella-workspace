import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';

Future<String?> showAddTextInputPopup(
  BuildContext context, {
  String title = 'Thêm mới dữ liệu',
  String hintText = 'Nhập thông tin',
  String cancelText = 'Hủy',
  String confirmText = 'Thêm',
}) {
  final controller = TextEditingController();
  final maxDialogWidth = math.min(
    SC.sw(343),
    MediaQuery.of(context).size.width - SC.sw(24),
  );

  return showDialog<String>(
    context: context,
    builder: (ctx) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: SC.sw(12)),
        backgroundColor: Colors.transparent,
        child: Container(
          width: maxDialogWidth,
          padding: EdgeInsets.all(SC.sw(16)),
          decoration: BoxDecoration(
            color: AC.white,
            borderRadius: BorderRadius.circular(SC.smin(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    fontSize: SC.sf(16),
                    height: 24 / 16,
                    color: AC.neutralDialogTitle,
                  ),
                ),
              ),
              SizedBox(height: SC.sh(16)),
              Container(
                width: double.infinity,
                height: SC.sh(48),
                padding: EdgeInsets.symmetric(
                  horizontal: SC.sw(12),
                  vertical: SC.sh(8),
                ),
                decoration: BoxDecoration(
                  color: AC.greyBox1,
                  borderRadius: BorderRadius.circular(SC.smin(16)),
                ),
                child: Center(
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    minLines: 1,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(14),
                      height: 18 / 14,
                      color: AC.blackText6,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w400,
                        fontSize: SC.sf(14),
                        height: 18 / 14,
                        color: AC.blackText6,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: SC.sh(24)),
                child: Row(
                  children: [
                    Expanded(
                      child: _PopupButton(
                        text: cancelText,
                        backgroundColor: AC.greyLine2,
                        textColor: AC.greyText5,
                        onTap: () => Navigator.of(ctx).pop(),
                      ),
                    ),
                    SizedBox(width: SC.sw(8)),
                    Expanded(
                      child: _PopupButton(
                        text: confirmText,
                        backgroundColor: AC.greenStrong1,
                        textColor: AC.white,
                        onTap: () =>
                            Navigator.of(ctx).pop(controller.text.trim()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _PopupButton extends StatelessWidget {
  const _PopupButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: onTap,
      child: Container(
        height: SC.sh(52),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(14),
            height: 20 / 14,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
