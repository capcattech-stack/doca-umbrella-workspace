import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/header/custom_app_header.dart';
import 'package:flutter_chat_mock_app/widgets/input/chips_creator_text_field.dart';
import 'package:flutter_chat_mock_app/widgets/keyboard_dismisser.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';

/// Screen chỉnh sửa các trường brief: traits, likes, dislikes, diet.
class BriefEditorScreen extends StatefulWidget {
  const BriefEditorScreen({
    super.key,
    required this.initialTraits,
    required this.initialLikes,
    required this.initialDislikes,
    required this.initialDiet,
    required this.onTraitsChanged,
    required this.onLikesChanged,
    required this.onDislikesChanged,
    required this.onDietChanged,
    required this.onConfirm,
  });

  final String initialTraits;
  final String initialLikes;
  final String initialDislikes;
  final String initialDiet;
  final ValueChanged<String> onTraitsChanged;
  final ValueChanged<String> onLikesChanged;
  final ValueChanged<String> onDislikesChanged;
  final ValueChanged<String> onDietChanged;
  final VoidCallback onConfirm;

  @override
  State<BriefEditorScreen> createState() => _BriefEditorScreenState();
}

class _BriefEditorScreenState extends State<BriefEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return AssistantVisibilityScope.hide(
      child: KeyboardDismisser(
        child: CustomScaffold(
          resizeToAvoidBottomInset: true,
          body: SafeAreaTopOnly(
            child: Padding(
              padding: EdgeInsetsGeometry.only(
                bottom: MQ.bottomPadding(context),
              ),
              child: Column(
                children: [
                  CustomAppHeader(
                    title: 'Tính cách & sở thích',
                    color: AC.white,
                    leftActionIcon: 'assets/icons/main-x.png',
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        SC.sw(16),
                        SC.sh(16),
                        SC.sw(16),
                        0,
                      ),
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel('Tính cách'),
                          SizedBox(height: SC.sh(8)),
                          ChipsCreatorTextField(
                            hintText: 'Nhập và bấm mũi tên để thêm tính cách',
                            initialChips: widget.initialTraits
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList(),
                            onChanged: (vals) =>
                                widget.onTraitsChanged(vals.join(', ')),
                          ),
                          SizedBox(height: SC.sh(16)),
                          _SectionLabel('Yêu thích'),
                          SizedBox(height: SC.sh(8)),
                          ChipsCreatorTextField(
                            hintText: 'Những điều bé thích',
                            initialChips: widget.initialLikes
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList(),
                            onChanged: (vals) =>
                                widget.onLikesChanged(vals.join(', ')),
                          ),
                          SizedBox(height: SC.sh(16)),
                          _SectionLabel('Không thích'),
                          SizedBox(height: SC.sh(8)),
                          ChipsCreatorTextField(
                            hintText: 'Những điều bé không thích',
                            initialChips: widget.initialDislikes
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList(),
                            onChanged: (vals) =>
                                widget.onDislikesChanged(vals.join(', ')),
                          ),
                          SizedBox(height: SC.sh(16)),
                          _SectionLabel('Thức ăn'),
                          SizedBox(height: SC.sh(8)),
                          ChipsCreatorTextField(
                            hintText: 'Chế độ ăn uống, kiêng kỵ',
                            initialChips: widget.initialDiet
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList(),
                            onChanged: (vals) =>
                                widget.onDietChanged(vals.join(', ')),
                          ),
                          SizedBox(height: SC.sh(16)),
                          ActionButton(
                            text: 'Xác nhận',
                            onTap: widget.onConfirm,
                          ),
                          SizedBox(height: SC.sh(16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w700,
        fontSize: SC.sf(14),
        color: AC.blackTitleStrong,
      ),
    );
  }
}
