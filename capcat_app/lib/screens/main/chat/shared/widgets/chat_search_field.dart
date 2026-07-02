import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';

class ChatSearchField extends StatelessWidget {
  const ChatSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Tìm kiếm',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SC.sw(12)),
      child: Container(
        height: SC.sh(44),
        padding: EdgeInsets.symmetric(horizontal: SC.sw(16)),
        decoration: BoxDecoration(
          color: const Color(0x29787880),
          borderRadius: BorderRadius.circular(SC.sw(100)),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: SC.sf(22), color: AC.neutralInfoHint),
            SizedBox(width: SC.sw(8)),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w400,
                    fontSize: SC.sf(17),
                    height: 22 / 17,
                    letterSpacing: -0.08,
                    color: AC.neutralInfoHint,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                  fontSize: SC.sf(16),
                  height: 22 / 16,
                  color: AC.blackText6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
