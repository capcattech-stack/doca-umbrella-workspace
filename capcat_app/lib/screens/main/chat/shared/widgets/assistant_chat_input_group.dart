import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';

class AssistantChatInputGroup extends StatelessWidget {
  const AssistantChatInputGroup({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isSending,
    required this.onSendText,
    required this.onTapCamera,
    required this.onTapImage,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isSending;
  final ValueChanged<String> onSendText;
  final VoidCallback onTapCamera;
  final VoidCallback onTapImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(SC.sw(16), SC.sh(12), SC.sw(16), SC.sh(12)),
      child: Container(
        height: SC.sh(92),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AC.white,
          border: Border.all(color: AC.greyCheckbox),
          borderRadius: BorderRadius.circular(SC.smin(24)),
        ),
        padding: EdgeInsets.symmetric(horizontal: SC.sw(16)),
        child: Column(
          children: [
            SizedBox(
              height: SC.sh(56),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(14),
                      height: 18 / 14,
                      color: AC.neutralInfoHint,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                    fontSize: SC.sf(14),
                    height: 18 / 14,
                    color: AC.blackText6,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SC.sh(26),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: Row(
                        children: [
                          _ActionChip(
                            label: 'Chụp ảnh',
                            icon: Icons.photo_camera_outlined,
                            onTap: onTapCamera,
                          ),
                          SizedBox(width: SC.sw(6)),
                          _ActionChip(
                            label: 'Hình ảnh',
                            icon: Icons.image_outlined,
                            onTap: onTapImage,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: SC.sw(8)),
                  AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) {
                      final raw = controller.text;
                      final canSend = raw.trim().isNotEmpty && !isSending;
                      return TapEffect(
                        onTap: canSend ? () => onSendText(raw) : null,
                        child: Container(
                          width: SC.smin(40),
                          height: SC.sh(26),
                          decoration: BoxDecoration(
                            color: canSend
                                ? AC.greenText1
                                : AC.greenText1.withAlpha((0.35 * 255).toInt()),
                            borderRadius: BorderRadius.circular(SC.smin(100)),
                            border: Border.all(
                              color: canSend
                                  ? AC.greenText1
                                  : AC.greenText1.withAlpha(
                                      (0.35 * 255).toInt(),
                                    ),
                            ),
                          ),
                          child: Icon(
                            Icons.send,
                            size: SC.smin(16),
                            color: AC.white,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: onTap,
      child: Container(
        height: SC.sh(26),
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(12),
          vertical: SC.sh(4),
        ),
        decoration: BoxDecoration(
          color: AC.white,
          border: Border.all(color: AC.greyCheckbox),
          borderRadius: BorderRadius.circular(SC.smin(100)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: SC.smin(16), color: AC.neutralPrimaryText),
            SizedBox(width: SC.sw(4)),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: SC.sf(8),
                height: 18 / 8,
                letterSpacing: 0.2,
                color: AC.blackText6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
