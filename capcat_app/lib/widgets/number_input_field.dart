import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class NumberInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const NumberInputField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.sw(327),
      height: SizeConfig.sh(56),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AC.greyBorder1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: SizeConfig.sf(14),
                  fontWeight: FontWeight.w400,
                  color: AC.greyText1,
                ),
              ),
              style: TextStyle(
                fontSize: SizeConfig.sf(14),
                color: AC.blackText5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
