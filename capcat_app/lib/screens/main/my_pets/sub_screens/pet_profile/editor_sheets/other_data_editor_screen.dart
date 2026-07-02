import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/models/pet_extra_note.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/services/pet_service.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:capcat_doca/widgets/keyboard_dismisser.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/loading/text_loading_indicator.dart';
import 'package:capcat_doca/widgets/popup/add_text_input_popup.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';

class OtherDataEditorScreen extends StatefulWidget {
  const OtherDataEditorScreen({
    super.key,
    required this.petId,
    required this.onExtrasChanged,
  });

  final String petId;
  final ValueChanged<String> onExtrasChanged;

  @override
  State<OtherDataEditorScreen> createState() => _OtherDataEditorScreenState();
}

class _OtherDataEditorScreenState extends State<OtherDataEditorScreen> {
  List<PetExtraNote> _extras = <PetExtraNote>[];
  bool _isLoading = true;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _loadExtraNotes();
  }

  void _notifyChanged() {
    widget.onExtrasChanged(
      _extras.map((e) => e.text).where((e) => e.isNotEmpty).join(', '),
    );
  }

  Future<void> _loadExtraNotes() async {
    final resp = await PetService.getPetExtraNotes(id: widget.petId);
    if (!mounted) return;

    if (resp.isSuccess) {
      final raw = resp.data;
      final loaded = raw is List<PetExtraNote> ? raw : <PetExtraNote>[];
      setState(() {
        _extras = loaded;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _extras = <PetExtraNote>[];
      _isLoading = false;
    });
    _notifyChanged();
  }

  Future<void> _showAddNoteDialog() async {
    final added = await showAddTextInputPopup(
      context,
      title: 'Thêm lưu ý',
      hintText: 'Nhập thông tin',
      cancelText: 'Hủy',
      confirmText: 'Thêm',
    );

    if (!mounted || added == null || added.trim().isEmpty || _isAdding) return;
    setState(() => _isAdding = true);

    final resp = await PetService.addPetExtraNote(
      id: widget.petId,
      text: added.trim(),
    );
    if (!mounted) return;

    if (resp.isSuccess) {
      final newNote = resp.data is PetExtraNote
          ? resp.data as PetExtraNote
          : PetExtraNote.fromText(added.trim());
      setState(() {
        _extras.add(newNote);
        _isAdding = false;
      });
      _notifyChanged();
      return;
    }

    setState(() => _isAdding = false);
    ToastOverlay.show(context, resp.message ?? 'Thêm lưu ý thất bại');
  }

  @override
  Widget build(BuildContext context) {
    return AssistantVisibilityScope.hide(
      child: KeyboardDismisser(
        child: CustomScaffold(
          resizeToAvoidBottomInset: true,
          body: SafeAreaTopOnly(
            child: Padding(
              padding: EdgeInsets.only(bottom: MQ.bottomPadding(context)),
              child: Column(
                children: [
                  CustomAppHeader(
                    title: 'Lưu ý khác',
                    color: AC.white,
                    leftActionIcon: 'assets/icons/main-x.png',
                  ),
                  if (_isLoading)
                    const Expanded(
                      child: Center(
                        child: TextLoadingIndicator(text: 'Đang tải lưu ý...'),
                      ),
                    )
                  else
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
                            Text(
                              'Lưu ý khác',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                                fontSize: SC.sf(14),
                                color: AC.blackTitleStrong,
                              ),
                            ),
                            SizedBox(height: SC.sh(8)),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AC.greyBox2),
                                borderRadius: BorderRadius.circular(
                                  SC.smin(16),
                                ),
                              ),
                              child: Column(
                                children: [
                                  for (int i = 0; i < _extras.length; i++)
                                    _OtherDataRow(
                                      text: _extras[i].text,
                                      hasAssistantIcon:
                                          _extras[i].isCreatedByAgent,
                                      isLast: false,
                                    ),
                                  _AddOtherDataRow(
                                    onTap: _isAdding
                                        ? () {}
                                        : _showAddNoteDialog,
                                    isLast: true,
                                  ),
                                ],
                              ),
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

class _OtherDataRow extends StatelessWidget {
  const _OtherDataRow({
    required this.text,
    required this.hasAssistantIcon,
    required this.isLast,
  });

  final String text;
  final bool hasAssistantIcon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: SC.sw(16), vertical: SC.sh(8)),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AC.greyBox2, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w400,
                fontSize: SC.sf(12),
                height: 1.25,
                color: AC.neutralPrimaryText,
              ),
            ),
          ),
          if (hasAssistantIcon) ...[
            SizedBox(width: SC.sw(8)),
            Container(
              width: SC.smin(16),
              height: SC.smin(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.smart_toy_rounded,
                size: SC.smin(12),
                color: AC.neutralPrimaryText,
              ),
            ),
          ],
          SizedBox(width: SC.sw(8)),
          Image.asset(
            'assets/icons/extra-notes-delete.png',
            width: SC.smin(20),
          ),
        ],
      ),
    );
  }
}

class _AddOtherDataRow extends StatelessWidget {
  const _AddOtherDataRow({required this.onTap, required this.isLast});

  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(16),
          vertical: SC.sh(16),
        ),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(bottom: BorderSide(color: AC.greyBox2, width: 1)),
        ),
        child: Row(
          children: [
            Icon(Icons.add, size: SC.smin(16), color: AC.neutralPrimaryText),
            SizedBox(width: SC.sw(8)),
            Expanded(
              child: Text(
                'Thêm lưu ý',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(12),
                  color: AC.neutralPrimaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
