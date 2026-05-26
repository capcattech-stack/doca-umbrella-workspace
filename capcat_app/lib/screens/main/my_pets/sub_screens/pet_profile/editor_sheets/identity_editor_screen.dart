import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/models/pet_species_master_data.dart';
import 'package:flutter_chat_mock_app/providers/pet_breed_repository_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_breeds_data_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_species_repository_provider.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/header/custom_app_header.dart';
import 'package:flutter_chat_mock_app/widgets/input/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/input/select_text_field.dart';
import 'package:flutter_chat_mock_app/widgets/keyboard_dismisser.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Full screen editor version of IdentityEditorSheet.
class IdentityEditorScreen extends ConsumerStatefulWidget {
  const IdentityEditorScreen({
    super.key,
    required this.initialGender,
    required this.initialIsNeutered,
    required this.initialBreed,
    required this.initialHairColor,
    required this.initialWeight,
    required this.initialAppearance,
    required this.speciesCode,
    required this.onGenderChanged,
    required this.onNeuteredChanged,
    required this.onBreedChanged,
    required this.onHairColorChanged,
    required this.onWeightChanged,
    required this.onAppearanceChanged,
    required this.onConfirm,
  });

  final PetGender initialGender;
  final bool initialIsNeutered;
  final String initialBreed;
  final String initialHairColor;
  final String initialWeight;
  final String initialAppearance;
  final String speciesCode;
  final ValueChanged<PetGender> onGenderChanged;
  final ValueChanged<bool> onNeuteredChanged;
  final ValueChanged<String> onBreedChanged;
  final ValueChanged<String> onHairColorChanged;
  final ValueChanged<String> onWeightChanged;
  final ValueChanged<String> onAppearanceChanged;
  final VoidCallback onConfirm;

  @override
  ConsumerState<IdentityEditorScreen> createState() =>
      _IdentityEditorScreenState();
}

class _IdentityEditorScreenState extends ConsumerState<IdentityEditorScreen> {
  late PetGender _gender;
  late bool _isNeutered;
  late TextEditingController _breedCtrl;
  late TextEditingController _hairCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _appearanceCtrl;

  @override
  void initState() {
    super.initState();
    _gender = widget.initialGender;
    _isNeutered = widget.initialIsNeutered;
    _breedCtrl = TextEditingController(text: widget.initialBreed);
    _hairCtrl = TextEditingController(text: widget.initialHairColor);
    _weightCtrl = TextEditingController(text: widget.initialWeight);
    _appearanceCtrl = TextEditingController(text: widget.initialAppearance);
  }

  @override
  void dispose() {
    _breedCtrl.dispose();
    _hairCtrl.dispose();
    _weightCtrl.dispose();
    _appearanceCtrl.dispose();
    super.dispose();
  }

  void _selectGender(PetGender gender) {
    setState(() => _gender = gender);
    widget.onGenderChanged(gender);
  }

  void _toggleNeutered() {
    setState(() => _isNeutered = !_isNeutered);
    widget.onNeuteredChanged(_isNeutered);
  }

  @override
  Widget build(BuildContext context) {
    final quickPicks = ref.watch(
      petBreedsProvider.select((s) => s.recentPetBreeds),
    );
    final breedsAsync = ref.watch(petBreedProvider);
    final speciesAsync = ref.watch(petSpeciesProvider);
    final allSpecies = speciesAsync.valueOrNull ?? [];
    final selectedSpecies = PetSpeciesMasterData.fromCode(
      widget.speciesCode,
      allSpecies,
    );

    List<String> breedOptions = const [];
    String hintText = 'Đang tải giống...';
    if (breedsAsync.hasError) {
      hintText = 'Không tải được danh sách giống';
    } else if (breedsAsync.hasValue) {
      final breeds = breedsAsync.value ?? [];
      final filtered = (selectedSpecies?.id != null)
          ? breeds.where((b) => b.parentId == selectedSpecies!.id).toList()
          : breeds;
      breedOptions = filtered.map((b) => b.name).toList();
      hintText = 'Chọn giống';
    }

    return AssistantVisibilityScope.hide(
      child: KeyboardDismisser(
        child: CustomScaffold(
          resizeToAvoidBottomInset: true,
          body: SafeAreaTopOnly(
            child: Padding(
              padding: EdgeInsetsGeometry.only(
                bottom: MQ.bottomPadding(context),
              ),
              // padding: EdgeInsets.zero,
              child: Column(
                children: [
                  CustomAppHeader(
                    title: 'Đặc điểm nhận dạng',
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
                        // MQ.bottomPadding(context) + SC.sh(16),
                      ),
                      // physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chọn giới tính',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: SC.sf(14),
                              color: AC.blackTitleStrong,
                            ),
                          ),
                          SizedBox(height: SC.sh(12)),
                          Row(
                            children: [
                              Expanded(
                                child: _GenderChip(
                                  label: 'Cái',
                                  selected: _gender == PetGender.female,
                                  selectedBg: AC.pinkSelectedBg,
                                  selectedBorder: AC.pinkGenderAccent,
                                  selectedText: AC.pinkGenderAccent,
                                  onTap: () => _selectGender(PetGender.female),
                                ),
                              ),
                              SizedBox(width: SC.sw(12)),
                              Expanded(
                                child: _GenderChip(
                                  label: 'Đực',
                                  selected: _gender == PetGender.male,
                                  selectedBg: AC.blueSelectedBg,
                                  selectedBorder: AC.blueGenderAccent,
                                  selectedText: AC.blueGenderAccent,
                                  onTap: () => _selectGender(PetGender.male),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SC.sh(16)),
                          Row(
                            children: [
                              TapEffect(
                                effect: TapEffectType.none,
                                onTap: _toggleNeutered,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Transform.scale(
                                      scale: SC.smin(24) / 18,
                                      child: Checkbox(
                                        value: _isNeutered,
                                        onChanged: (_) => _toggleNeutered(),
                                        activeColor: AC.greenStrong1,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        side: BorderSide(
                                          color: AC.greyCheckbox,
                                          width: SC.smin(2),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: SC.sw(4)),
                                    Text(
                                      'Đã triệt sản',
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w500,
                                        fontSize: SC.sf(14),
                                        color: AC.blackText6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SC.sh(16)),
                          Text(
                            'Giống',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: SC.sf(14),
                              color: AC.blackTitleStrong,
                            ),
                          ),
                          SizedBox(height: SC.sh(8)),
                          SelectTextField(
                            controller: _breedCtrl,
                            fullOptions: breedOptions,
                            quickOptions: quickPicks,
                            hintText: hintText,
                            sheetTitle: 'Chọn giống',
                            searchHint: 'Tìm giống',
                            allSectionText: 'Tất cả',
                            readOnly: true,
                            onChanged: (val) =>
                                widget.onBreedChanged(val ?? ''),
                            isMiniVersion: true,
                          ),
                          SizedBox(height: SC.sh(16)),
                          Text(
                            'Màu lông',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: SC.sf(14),
                              color: AC.blackTitleStrong,
                            ),
                          ),
                          SizedBox(height: SC.sh(8)),
                          InputField(
                            hintText: 'Nhập màu lông',
                            controller: _hairCtrl,
                            onChanged: widget.onHairColorChanged,
                          ),
                          SizedBox(height: SC.sh(16)),
                          Text(
                            'Cân nặng (kg)',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: SC.sf(14),
                              color: AC.blackTitleStrong,
                            ),
                          ),
                          SizedBox(height: SC.sh(8)),
                          InputField(
                            hintText: 'Nhập cân nặng',
                            controller: _weightCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: widget.onWeightChanged,
                          ),
                          SizedBox(height: SC.sh(16)),
                          Text(
                            'Ngoại hình và dấu hiệu đặc trưng',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: SC.sf(14),
                              color: AC.blackTitleStrong,
                            ),
                          ),
                          SizedBox(height: SC.sh(8)),
                          InputField(
                            hintText: 'Mô tả ngoại hình, dấu hiệu đặc trưng',
                            controller: _appearanceCtrl,
                            isLarge: true,
                            onChanged: widget.onAppearanceChanged,
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

class _GenderChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedBg;
  final Color selectedBorder;
  final Color selectedText;
  final VoidCallback onTap;

  const _GenderChip({
    required this.label,
    required this.selected,
    required this.selectedBg,
    required this.selectedBorder,
    required this.selectedText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? selectedBg : AC.greyTab1;
    final border = selected ? selectedBorder : AC.neutralChipBorder;
    final textColor = selected ? selectedText : AC.blackText6;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(12),
          vertical: SC.sh(12),
        ),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w600,
            fontSize: SC.sf(14),
            color: textColor,
          ),
        ),
      ),
    );
  }
}
