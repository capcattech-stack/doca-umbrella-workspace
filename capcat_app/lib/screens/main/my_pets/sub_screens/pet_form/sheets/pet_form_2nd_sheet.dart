import 'package:flutter/material.dart';
import 'package:capcat_doca/models/pet_species_master_data.dart';
import 'package:capcat_doca/providers/pet_breed_repository_provider.dart';
import 'package:capcat_doca/providers/pet_breeds_data_provider.dart';
import 'package:capcat_doca/providers/pet_form_providers.dart';
import 'package:capcat_doca/providers/pet_species_repository_provider.dart';
import 'package:capcat_doca/widgets/input/select_text_field.dart';
import 'package:capcat_doca/utils/date_format_config.dart';
import 'package:capcat_doca/widgets/text/section_header_text.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/sheets/widgets/tag_selection.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/widgets/input/input_field.dart';
import 'package:capcat_doca/widgets/input/date_input_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/theme/app_colors.dart';

class PetForm2ndSheet extends ConsumerWidget {
  const PetForm2ndSheet({super.key, this.actionButton});
  final Widget? actionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final double hp = SC.sw(24);
    final double vpS = SC.sh(8);
    final double vpM = SC.sh(16);
    final double largeVp = SC.sh(24);
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: MQ.bottomPadding(context)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: largeVp),
              //--Species
              SectionHeaderText(l10n.petFormSpeciesLabel, isOptional: true),
              SizedBox(height: vpS),
              const _SelectSpeciesWidget(),
              SizedBox(height: vpM),
              //--Breed
              SectionHeaderText(l10n.petFormBreedLabel, isOptional: true),
              SizedBox(height: vpS),
              const _SelectBreedWidget(),
              SizedBox(height: vpM),
              //--Weight
              SectionHeaderText(l10n.petFormWeightLabel),
              SizedBox(height: vpS),
              const _InputWeightField(),
              SizedBox(height: vpM),
              //--Hair color
              SectionHeaderText(l10n.petFormHairColorLabel, isOptional: true),
              SizedBox(height: vpS),
              const _InputHairColorField(),
              SizedBox(height: vpM),
              //--Date of birth
              SectionHeaderText(l10n.petFormBirthdayLabel),
              SizedBox(height: vpS),
              const _InputBirthdayField(),
              SizedBox(height: vpM),
              //--Adopted Date
              SectionHeaderText(l10n.petFormAdoptionLabel, isOptional: true),
              SizedBox(height: vpS),
              const _InputAdoptedDayField(),
              SizedBox(height: vpM),
              //--Detail Info
              SectionHeaderText(l10n.petFormDetailInfoLabel, isOptional: true),
              SizedBox(height: vpS),
              const _InputDescriptionField(),
              SizedBox(height: vpM),
              //--Appearance
              SectionHeaderText(l10n.petFormAppearanceLabel, isOptional: true),
              SizedBox(height: vpS),
              const _InputAppearanceDetailField(),
              SizedBox(height: vpM),
              actionButton ?? const SizedBox(),
              SizedBox(height: vpM),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectSpeciesWidget extends ConsumerWidget {
  const _SelectSpeciesWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCode = ref.watch(
      petFormDataProvider.select((s) => s.speciesCode),
    );
    final formNotifier = ref.read(petFormDataProvider.notifier);
    final speciesAsync = ref.watch(petSpeciesProvider);

    return speciesAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),

      error: (e, _) {
        final fallback = _fallbackItems(context);
        final resolvedCode = selectedCode ?? fallback.first.value.code;
        if (selectedCode == null) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => formNotifier.setSpeciesCode(resolvedCode),
          );
        }

        return TagSelector<String>(
          value: resolvedCode,
          onChanged: formNotifier.setSpeciesCode,
          items: fallback
              .map(
                (item) => TagItem<String>(
                  value: item.value.code,
                  label: item.label,
                  selectedBg: item.selectedBg,
                  selectedBorder: item.selectedBorder,
                  selectedText: item.selectedText,
                ),
              )
              .toList(),
        );
      },

      data: (options) {
        final validOptions = options
            .where((o) => o.code == 'dog' || o.code == 'cat')
            .toList();

        final tagItems = validOptions.isEmpty
            ? _fallbackItems(context)
            : validOptions.map(_toTagItem).toList();

        final resolvedCode = selectedCode ?? tagItems.first.value.code;
        if (selectedCode == null) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => formNotifier.setSpeciesCode(resolvedCode),
          );
        }

        return TagSelector<String>(
          value: resolvedCode,
          onChanged: formNotifier.setSpeciesCode,
          items: tagItems
              .map(
                (t) => TagItem<String>(
                  value: t.value.code,
                  label: t.label,
                  selectedBg: t.selectedBg,
                  selectedBorder: t.selectedBorder,
                  selectedText: t.selectedText,
                ),
              )
              .toList(),
        );
      },
    );
  }

  TagItem<PetSpeciesMasterData> _toTagItem(PetSpeciesMasterData option) {
    return TagItem(
      value: option,
      label: option.name,
      selectedBg: AC.greenSelectedBg,
      selectedBorder: AC.greenSelectedAccent,
      selectedText: AC.greenSelectedAccent,
    );
  }

  List<TagItem<PetSpeciesMasterData>> _fallbackItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      TagItem(
        value: const PetSpeciesMasterData(
          id: -1,
          type: 'species',
          code: 'dog',
          name: 'dog',
          parentId: null,
        ),
        label: l10n.petFormSpeciesDog,
        selectedBg: AC.greenSelectedBg,
        selectedBorder: AC.greenSelectedAccent,
        selectedText: AC.greenSelectedAccent,
      ),
      TagItem(
        value: const PetSpeciesMasterData(
          id: -2,
          type: 'species',
          code: 'cat',
          name: 'cat',
          parentId: null,
        ),
        label: l10n.petFormSpeciesCat,
        selectedBg: AC.greenSelectedBg,
        selectedBorder: AC.greenSelectedAccent,
        selectedText: AC.greenSelectedAccent,
      ),
    ];
  }
}

// ---------------------------------------------------------------------------
//  Breed selector (lọc theo parentId thông qua speciesCode)
// ---------------------------------------------------------------------------
class _SelectBreedWidget extends ConsumerStatefulWidget {
  const _SelectBreedWidget();

  @override
  ConsumerState<_SelectBreedWidget> createState() => _SelectBreedWidgetState();
}

class _SelectBreedWidgetState extends ConsumerState<_SelectBreedWidget> {
  late final TextEditingController _breedController;

  @override
  void initState() {
    super.initState();
    final initialBreed = ref.read(petFormDataProvider.select((s) => s.breed));
    _breedController = TextEditingController(text: initialBreed ?? '');
  }

  @override
  void dispose() {
    _breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quickPicks = ref.watch(
      petBreedsProvider.select((s) => s.recentPetBreeds),
    );
    final breedsAsync = ref.watch(petBreedProvider);
    final speciesCode = ref.watch(
      petFormDataProvider.select((s) => s.speciesCode),
    );
    final speciesListAsync = ref.watch(petSpeciesProvider);
    final petFormNotifier = ref.read(petFormDataProvider.notifier);

    // lấy master species object tương ứng code
    PetSpeciesMasterData? selectedSpecies;
    speciesListAsync.whenData((all) {
      selectedSpecies = PetSpeciesMasterData.fromCode(speciesCode ?? '', all);
    });

    return breedsAsync.when(
      loading: () => SelectTextField(
        fullOptions: const [],
        quickOptions: quickPicks,
        hintText: 'Giống (đang tải...)',
        sheetTitle: 'Chọn giống',
        searchHint: 'Tìm giống',
        allSectionText: 'Tất cả các giống',
        controller: _breedController,
        readOnly: true,
        onChanged: (_) {},
      ),
      error: (e, _) => SelectTextField(
        fullOptions: const [],
        quickOptions: quickPicks,
        hintText: 'Giống (tải lỗi)',
        sheetTitle: 'Chọn giống',
        searchHint: 'Tìm giống',
        allSectionText: 'Tất cả các giống',
        controller: _breedController,
        readOnly: true,
        onChanged: (_) {},
      ),
      data: (breeds) {
        final filteredBreeds = (selectedSpecies != null)
            ? breeds.where((b) => b.parentId == selectedSpecies!.id).toList()
            : breeds;

        final allBreeds = filteredBreeds.map((b) => b.name).toList();

        return SelectTextField(
          fullOptions: allBreeds,
          quickOptions: quickPicks,
          hintText: 'Giống',
          sheetTitle: 'Chọn giống',
          searchHint: 'Tìm giống',
          allSectionText: 'Tất cả các giống',
          controller: _breedController,
          onChanged: (selected) {
            if (selected != null && selected.trim().isNotEmpty) {
              ref.read(petBreedsProvider.notifier).addToRecent(selected);
            }
            petFormNotifier.setBreed(selected);
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
//  Các field khác (weight, hair, birthday, adopted, description...)
// ---------------------------------------------------------------------------
class _InputWeightField extends ConsumerStatefulWidget {
  const _InputWeightField();

  @override
  ConsumerState<_InputWeightField> createState() => _InputWeightFieldState();
}

class _InputWeightFieldState extends ConsumerState<_InputWeightField> {
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final initialWeight = ref.read(petFormDataProvider.select((s) => s.weight));
    _weightController = TextEditingController(
      text: initialWeight?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petFormNotifier = ref.read(petFormDataProvider.notifier);

    return InputField(
      hintText: 'Cân nặng',
      controller: _weightController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (text) {
        final cleaned = text.trim().replaceAll(',', '.');
        final value = double.tryParse(cleaned);
        if (value != null) {
          petFormNotifier.setWeight(value);
        }
      },
    );
  }
}

// Các field còn lại giữ nguyên logic cũ -------------------------------
class _InputHairColorField extends ConsumerStatefulWidget {
  const _InputHairColorField();

  @override
  ConsumerState<_InputHairColorField> createState() =>
      _InputHairColorFieldState();
}

class _InputHairColorFieldState extends ConsumerState<_InputHairColorField> {
  late final TextEditingController _hairColorController;
  @override
  void initState() {
    super.initState();
    final initialHairColor = ref.read(
      petFormDataProvider.select((s) => s.hairColor),
    );
    _hairColorController = TextEditingController(text: initialHairColor ?? '');
  }

  @override
  void dispose() {
    _hairColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petFormNotifier = ref.read(petFormDataProvider.notifier);
    return InputField(
      hintText: 'Màu lông',
      controller: _hairColorController,
      onChanged: petFormNotifier.setHairColor,
    );
  }
}

//--Birthday
class _InputBirthdayField extends ConsumerStatefulWidget {
  const _InputBirthdayField();

  @override
  ConsumerState<_InputBirthdayField> createState() =>
      _InputBirthdayFieldState();
}

class _InputBirthdayFieldState extends ConsumerState<_InputBirthdayField> {
  @override
  Widget build(BuildContext context) {
    final birthdayIso = ref.read(petFormDataProvider.select((s) => s.birthday));

    DateTime? initialDate;
    if (birthdayIso != null && birthdayIso.isNotEmpty) {
      try {
        initialDate = DateTime.parse(birthdayIso);
      } catch (_) {
        initialDate = null;
      }
    }

    final petFormNotifier = ref.read(petFormDataProvider.notifier);

    return DateInputField(
      hintText: 'Ngày sinh',
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      onChanged: (value) {
        if (value != null) {
          final iso = DateFormatConfig.dateOnlyToIsoLocal(value);
          petFormNotifier.setBirthday(iso);
          final adoptedDate = ref.read(
            petFormDataProvider.select((s) => s.adoptedDate),
          );
          if (adoptedDate == null || adoptedDate.isEmpty) {
            petFormNotifier.setAdoptedDay(iso);
          }
        } else {
          petFormNotifier.setBirthday(null);
        }
      },
    );
  }
}

//--Adopted day
class _InputAdoptedDayField extends ConsumerStatefulWidget {
  const _InputAdoptedDayField();

  @override
  ConsumerState<_InputAdoptedDayField> createState() =>
      _InputAdoptedDayFieldState();
}

class _InputAdoptedDayFieldState extends ConsumerState<_InputAdoptedDayField> {
  @override
  Widget build(BuildContext context) {
    final adoptedDateIso = ref.watch(
      petFormDataProvider.select((s) => s.adoptedDate),
    );

    DateTime? initialDate;
    if (adoptedDateIso != null && adoptedDateIso.isNotEmpty) {
      try {
        initialDate = DateTime.parse(adoptedDateIso);
      } catch (_) {
        initialDate = null;
      }
    }

    final petFormNotifier = ref.read(petFormDataProvider.notifier);

    return DateInputField(
      hintText: 'Ngày nhận nuôi',
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      onChanged: (value) {
        if (value != null) {
          petFormNotifier.setAdoptedDay(
            DateFormatConfig.dateOnlyToIsoLocal(value),
          );
        } else {
          petFormNotifier.setAdoptedDay(null);
        }
      },
    );
  }
}

//--Description
class _InputDescriptionField extends ConsumerStatefulWidget {
  const _InputDescriptionField();

  @override
  ConsumerState<_InputDescriptionField> createState() =>
      _InputDescriptionFieldState();
}

class _InputDescriptionFieldState
    extends ConsumerState<_InputDescriptionField> {
  late final TextEditingController _hairColorController;
  @override
  void initState() {
    super.initState();
    final initialDescription = ref.read(
      petFormDataProvider.select((s) => s.description),
    );
    _hairColorController = TextEditingController(
      text: initialDescription ?? '',
    );
  }

  @override
  void dispose() {
    _hairColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petFormNotifier = ref.read(petFormDataProvider.notifier);

    return InputField(
      hintText: 'Nhập thông tin',
      isLarge: true,
      controller: _hairColorController,
      onChanged: petFormNotifier.setDescription,
    );
  }
}

//--Appearance detail
class _InputAppearanceDetailField extends ConsumerStatefulWidget {
  const _InputAppearanceDetailField();

  @override
  ConsumerState<_InputAppearanceDetailField> createState() =>
      _InputAppearanceDetailFieldState();
}

class _InputAppearanceDetailFieldState
    extends ConsumerState<_InputAppearanceDetailField> {
  late final TextEditingController _appearanceDetailController;
  @override
  void initState() {
    super.initState();
    final initialAppearanceDetail = ref.read(
      petFormDataProvider.select((s) => s.appearanceDetail),
    );
    _appearanceDetailController = TextEditingController(
      text: initialAppearanceDetail ?? '',
    );
  }

  @override
  void dispose() {
    _appearanceDetailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petFormNotifier = ref.read(petFormDataProvider.notifier);

    return InputField(
      hintText: 'Nhập thông tin',
      isLarge: true,
      controller: _appearanceDetailController,
      onChanged: petFormNotifier.setAppearanceDetail,
    );
  }
}
