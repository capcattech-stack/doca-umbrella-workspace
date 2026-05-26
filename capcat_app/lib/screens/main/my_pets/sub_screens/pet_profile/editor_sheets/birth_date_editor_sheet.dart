import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/input/date_input_field.dart';
import 'package:flutter_chat_mock_app/widgets/sheets/custom_action_sheet_container.dart';

/// Action sheet bundle for PetProfile related flows.
class BirthDateEditorSheet extends StatelessWidget {
  final String? ageText;
  final DateTime? birthday;
  final DateTime? adoptedDate;
  final String birthHint;
  final String adoptedHint;
  final ValueChanged<DateTime?> onBirthChanged;
  final ValueChanged<DateTime?> onAdoptedChanged;
  final VoidCallback onConfirm;

  const BirthDateEditorSheet({
    super.key,
    this.ageText,
    required this.birthday,
    required this.adoptedDate,
    this.birthHint = 'Chọn ngày sinh',
    this.adoptedHint = 'Chọn ngày nhận nuôi',
    required this.onBirthChanged,
    required this.onAdoptedChanged,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CustomActionSheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // _HeroCard(title: ageText),
          // SizedBox(height: SC.sh(16)),
          _DatesGroup(
            birthDate: birthday,
            adoptedDate: adoptedDate,
            birthHint: birthHint,
            adoptedHint: adoptedHint,
            onBirthChanged: onBirthChanged,
            onAdoptedChanged: onAdoptedChanged,
          ),
          SizedBox(height: SC.sh(16)),
          ActionButton(text: 'Xác nhận', onTap: onConfirm),
          SizedBox(height: SC.sh(16)),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String? title;
  const _HeroCard({this.title});

  @override
  Widget build(BuildContext context) {
    final heading = (title != null && title!.isNotEmpty)
        ? title!
        : 'Sinh nhật của bé';
    return Container(
      width: double.infinity,
      height: SC.sh(128),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AC.white, AC.yellowToolPanel],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(12),
          vertical: SC.sh(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      fontSize: SC.sf(14),
                      color: AC.blackText6,
                    ),
                  ),
                  SizedBox(height: SC.sh(6)),
                  Text(
                    'Giúp tính tuổi, giai đoạn phát triển\nvà nhắc nhở sự kiện quan trọng.',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(10),
                      color: AC.greyText4,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: SC.sw(16)),
          ],
        ),
      ),
    );
  }
}

class _DatesGroup extends StatelessWidget {
  final DateTime? birthDate;
  final DateTime? adoptedDate;
  final String birthHint;
  final String adoptedHint;
  final ValueChanged<DateTime?> onBirthChanged;
  final ValueChanged<DateTime?> onAdoptedChanged;
  const _DatesGroup({
    required this.birthDate,
    required this.adoptedDate,
    required this.birthHint,
    required this.adoptedHint,
    required this.onBirthChanged,
    required this.onAdoptedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SC.sw(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Chọn ngày sinh',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(14),
                  color: AC.blackText4,
                ),
              ),
              SizedBox(width: SC.sw(4)),
              Text(
                '*',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(12),
                  color: AC.redValidationText,
                ),
              ),
            ],
          ),
          SizedBox(height: SC.sh(8)),
          DateInputField(
            hintText: birthHint,
            initialDate: birthDate,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            onChanged: onBirthChanged,
          ),
          SizedBox(height: SC.sh(16)),
          Text(
            'Chọn ngày nhận nuôi',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
              fontSize: SC.sf(14),
              color: AC.blackText4,
            ),
          ),
          SizedBox(height: SC.sh(8)),
          DateInputField(
            hintText: adoptedHint,
            initialDate: adoptedDate,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            onChanged: onAdoptedChanged,
          ),
        ],
      ),
    );
  }
}
