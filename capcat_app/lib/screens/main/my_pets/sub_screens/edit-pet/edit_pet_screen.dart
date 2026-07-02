import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/models/pet_species_master_data.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart';
import 'package:capcat_doca/providers/loading_overlay_provider.dart';
import 'package:capcat_doca/providers/pet_breed_repository_provider.dart';
import 'package:capcat_doca/providers/pet_breeds_data_provider.dart';
import 'package:capcat_doca/providers/pet_form_providers.dart';
import 'package:capcat_doca/providers/pet_species_repository_provider.dart';
import 'package:capcat_doca/services/pet_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/button/action_button.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:capcat_doca/widgets/input/select_text_field.dart';
import 'package:capcat_doca/widgets/loading_overlay_widget.dart';
import 'package:capcat_doca/widgets/popup/custom_action_popup.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/enums/image_upload_purpose.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/utils/image_utils.dart';
import 'package:capcat_doca/widgets/text/section_header_text.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/sheets/widgets/tag_selection.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/input/input_field.dart';
import 'package:capcat_doca/widgets/shared/avatar_widget.dart';
import 'package:capcat_doca/utils/date_format_config.dart';
import 'package:capcat_doca/widgets/input/date_input_field.dart';
import 'package:capcat_doca/services/image_service.dart';
import 'package:capcat_doca/services/image_picker_service.dart';

class EditPetScreen extends ConsumerStatefulWidget {
  final PetDetail? pet;
  const EditPetScreen({super.key, this.pet});

  @override
  ConsumerState<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends ConsumerState<EditPetScreen> {
  @override
  void initState() {
    super.initState();
    // Load dữ liệu master data ngay khi vào màn hình
    Future.microtask(() async {
      final speciesState = ref.read(petSpeciesProvider);
      final breedState = ref.read(petBreedProvider);

      final tasks = <Future<void>>[];

      final speciesList = speciesState.valueOrNull;
      if (speciesList == null || speciesList.isEmpty) {
        tasks.add(ref.read(petSpeciesProvider.notifier).refresh());
      }

      final breedList = breedState.valueOrNull;
      if (breedList == null || breedList.isEmpty) {
        tasks.add(ref.read(petBreedProvider.notifier).refresh());
      }

      if (tasks.isNotEmpty) {
        await Future.wait(tasks);
      }
    });
  }

  void _showMessage(String message) {
    TO.show(context, message);
  }

  Future<void> _onAvatarPicked(String avatarUrl) async {
    final l10n = AppLocalizations.of(context)!;
    final loadingOverlay = ref.read(loadingOverlayProvider.notifier);
    loadingOverlay.show(l10n.editPetCheckingImage);

    final formNotifier = ref.read(petFormDataProvider.notifier);
    final form = ref.read(petFormDataProvider);

    final serviceResponse = await PetService.getPetAvatarAnalyses(
      imageUrl: avatarUrl,
      name: form.name!,
      gender: form.gender.value,
      isSterilized: form.isNeutered,
    );

    if (!mounted) {
      loadingOverlay.hide();
      return;
    }

    if (!serviceResponse.isSuccess) {
      loadingOverlay.hide();

      TO.show(
        context,
        (serviceResponse.message?.trim().isNotEmpty == true)
            ? serviceResponse.message!
            : l10n.editPetGenericError,
      );
      return;
    }

    final data = serviceResponse.data;
    debugPrint('[editPetScreen_getPetAvatarAnalyses]${data.toString()}');

    final Map<String, dynamic> dataModeration = data['moderation'] ?? {};
    final rejected = dataModeration['rejected'] ?? false;

    if (rejected == true) {
      final isPet = dataModeration['is_pet'] ?? false;
      loadingOverlay.hide();

      if (!isPet) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => CustomActionPopup(
            title: l10n.editPetNotRecognizedTitle,
            message: l10n.editPetNotRecognizedMessage,
            primaryText: l10n.editPetNotRecognizedRetry,
            onPrimaryTap: () {
              Navigator.pop(context); // Đóng popup
            },
          ),
        );
      } else {
        TO.show(
          context,
          (serviceResponse.message?.trim().isNotEmpty == true)
              ? serviceResponse.message!
              : l10n.editPetTryAnotherImage,
        );
      }
      return;
    }

    formNotifier.setAvatarUrl(avatarUrl);

    final Map<String, dynamic> dataExtraction = data['extraction'] ?? {};

    final newBreed = dataExtraction['breed'];
    final newColor = dataExtraction['color'];
    final newBio = dataExtraction['bio'];
    final newDescription = dataExtraction['description'];
    final newWeight = (dataExtraction['weight'] != null)
        ? double.tryParse(dataExtraction['weight'].toString())
        : null;

    final bool hasChanged = [
      newBreed != null && newBreed != form.breed,
      newColor != null && newColor != form.hairColor,
      newBio != null && newBio != form.description,
      newDescription != null && newDescription != form.appearanceDetail,
      newWeight != null && newWeight != form.weight,
    ].any((changed) => changed);

    loadingOverlay.hide();

    if (!mounted) return;

    if (hasChanged) {
      debugPrint('🟢 Dữ liệu mới khác với form, hiển thị popup xác nhận');

      await showDialog(
        context: context,
        barrierDismissible: false, // ❗ Không thể tắt popup bằng chạm ngoài
        builder: (_) => CustomActionPopup(
          title: l10n.editPetSuggestionTitle,
          message: l10n.editPetSuggestionMessage,
          primaryText: l10n.editPetSuggestionPrimary,
          primaryLeadingIcon: Image.asset(
            'assets/icons/sparkles-white.png',
            width: SC.sw(24),
          ),
          onPrimaryTap: () {
            // ✅ Cập nhật form với dữ liệu mới
            if (newBreed != null) formNotifier.setBreed(newBreed);
            if (newColor != null) formNotifier.setHairColor(newColor);
            if (newBio != null) formNotifier.setDescription(newBio);
            if (newDescription != null) {
              formNotifier.setAppearanceDetail(newDescription);
            }
            if (newWeight != null) formNotifier.setWeight(newWeight);

            Navigator.pop(context); // Đóng popup
            TO.show(context, l10n.editPetSuggestionToast);
          },
          secondaryText: l10n.editPetSuggestionSecondary,
          onSecondaryTap: () {
            Navigator.pop(context); // Chỉ đóng popup, không đổi gì
          },
        ),
      );
    } else {
      debugPrint('🟡 Không có thay đổi nào so với form hiện tại');
    }
  }

  Future<void> _onSaveTap() async {
    final l10n = AppLocalizations.of(context)!;
    final form = ref.read(petFormDataProvider);

    if (form.id == null) {
      _showMessage(l10n.editPetGetInfoError);
      return;
    }
    if (form.name == null || form.name!.isEmpty) {
      _showMessage(l10n.editPetNameRequired);
      return;
    }
    if (form.breed == null || form.breed!.isEmpty) {
      _showMessage(l10n.editPetBreedRequired);
      return;
    }
    if (form.birthday == null || form.birthday!.isEmpty) {
      _showMessage(l10n.editPetBirthdayRequired);
      return;
    }

    final response = await PetService.updatePet(form);
    if (!mounted) return;

    if (response.isSuccess) {
      final data = response.data;
      final String id = data['id'];
      ref.read(petFormDataProvider.notifier).setId(id);

      final newPet = PetDetail.fromForm(form, id: id);
      await ref.read(listPetDetailProvider.notifier).upsertPet(newPet);
      if (!mounted) return;
      TO.show(context, l10n.editPetSaveSuccess);
      Navigator.of(context).pop();
    } else {
      _showMessage(response.message ?? l10n.editPetSaveFail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.watch(petBreedProvider);
    ref.watch(petSpeciesProvider);
    return AssistantVisibilityScope.hide(
      child: Stack(
        children: [
          CustomScaffold(
            backgroundColor: AppColors.white,
            resizeToAvoidBottomInset: false,
            body: SafeAreaTopOnly(
              child: Column(
                children: [
                  CustomAppHeader(
                    title: l10n.editPetTitle,
                    hasLeftAction: true,
                    leftActionIcon: 'assets/icons/main-x.png',
                    color: AC.white,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(
                        bottom: MQ.bottomPadding(context),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          left: SC.sw(24),
                          right: SC.sw(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: SC.sh(24)),

                            // --- Avatar, Name, Gender, Neutered
                            _SelectAvatarWidget(
                              onImagePicked: (imageUrl) async {
                                await _onAvatarPicked(imageUrl);
                              },
                            ),
                            SizedBox(height: SC.sh(24)),
                            SectionHeaderText(l10n.editPetNameLabel),
                            SizedBox(height: SC.sh(8)),
                            const _InputNameField(),
                            SizedBox(height: SC.sh(16)),
                            SectionHeaderText(
                              l10n.editPetGenderLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: SC.sh(8)),
                            const _SelectGenderWidget(),
                            SizedBox(height: SC.sh(16)),
                            const _IsNeuteredCheckboxWidget(),
                            SizedBox(height: SC.sh(16)),

                            // --- Species, Breed, Weight, Hair, Birthday, Adopted
                            SectionHeaderText(
                              l10n.editPetSpeciesLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: SC.sh(8)),
                            const _SelectSpeciesWidget(),
                            SizedBox(height: SC.sh(16)),
                            SectionHeaderText(
                              l10n.editPetBreedLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: SC.sh(8)),
                            const _SelectBreedWidget(),
                            SizedBox(height: SC.sh(16)),
                            SectionHeaderText(l10n.editPetWeightLabel),
                            SizedBox(height: SC.sh(8)),
                            const _InputWeightField(),
                            SizedBox(height: SC.sh(16)),
                            SectionHeaderText(
                              l10n.editPetHairColorLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: SC.sh(8)),
                            const _InputHairColorField(),
                            SizedBox(height: SC.sh(16)),
                            SectionHeaderText(l10n.editPetBirthdayLabel),
                            SizedBox(height: SC.sh(8)),
                            const _InputBirthdayField(),
                            SizedBox(height: SC.sh(16)),
                            SectionHeaderText(
                              l10n.editPetAdoptedLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: SC.sh(8)),
                            const _InputAdoptedDayField(),
                            SizedBox(height: SC.sh(16)),
                            SectionHeaderText(
                              l10n.editPetDetailLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: SC.sh(8)),
                            const _InputDescriptionField(),
                            SizedBox(height: SC.sh(16)),
                            SectionHeaderText(
                              l10n.editPetAppearanceLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: SC.sh(8)),
                            const _InputAppearanceDetailField(),

                            // const SizedBox(height: 40),
                            // ActionButton(
                            //   text: 'Phân tích ảnh và gợi ý thông tin',
                            //   onTap: _onAnalyzeTap,
                            // ),
                            SizedBox(height: SC.sh(16)),
                            ActionButton(
                              text: l10n.editPetSaveButton,
                              trailingIcon: Image.asset(
                                'assets/icons/ab-check.png',
                              ),
                              onTap: _onSaveTap,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // LoadingOverlayWidget(),
        ],
      ),
    );
  }
}

//--------------------------------------------------------------------------//
//--------------------------- Internal Widgets -----------------------------//
//--------------------------------------------------------------------------//

class _SelectAvatarWidget extends ConsumerWidget {
  const _SelectAvatarWidget({this.onImagePicked});

  /// Callback sau khi người dùng chọn ảnh thành công
  final void Function(String imageUrl)? onImagePicked;

  Future<void> _onEditTap(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final picked = await ImagePickerService.pickImages(
      context,
      allowMultiple: false,
      allowCamera: true,
      allowGallery: true,
    );
    final path = picked?.paths.firstOrNull;
    if (path == null) return;

    final result = await ImageService.uploadImageFromPath(
      imagePath: path,
      purpose: ImageUploadPurpose.petAvatar,
    );

    if (!result.isSuccess) {
      if (context.mounted) {
        TO.show(context, result.error ?? l10n.editPetGenericError);
      }
      return;
    }

    final imageUrl = result.fileUrl!;

    onImagePicked?.call(imageUrl);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUrl = ref.watch(petFormDataProvider.select((s) => s.avatarUrl));
    return Center(
      child: AvatarWidget(
        imageUrl: avatarUrl,
        isPet: true,
        size: SC.sh(100),
        editIconPath: 'assets/icons/take-avatar.png',
        onEditTap: () => _onEditTap(context, ref),
      ),
    );
  }
}

class _InputNameField extends ConsumerStatefulWidget {
  const _InputNameField();

  @override
  ConsumerState<_InputNameField> createState() => _InputNameFieldState();
}

class _InputNameFieldState extends ConsumerState<_InputNameField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: ref.read(petFormDataProvider.select((s) => s.name)),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(petFormDataProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    return InputField(
      hintText: l10n.editPetNameHint,
      controller: _ctrl,
      onChanged: notifier.setName,
    );
  }
}

class _SelectGenderWidget extends ConsumerWidget {
  const _SelectGenderWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gender = ref.watch(petFormDataProvider.select((s) => s.gender));
    final l10n = AppLocalizations.of(context)!;
    final items = [
      TagItem(
        value: PetGender.female,
        label: l10n.petFormGenderFemale,
        selectedBg: AC.pinkSelectedBg,
        selectedBorder: AC.pinkGenderAccent,
        selectedText: AC.pinkGenderAccent,
      ),
      TagItem(
        value: PetGender.male,
        label: l10n.petFormGenderMale,
        selectedBg: AC.blueSelectedBg,
        selectedBorder: AC.blueGenderAccent,
        selectedText: AC.blueGenderAccent,
      ),
    ];
    return TagSelector<PetGender>(
      value: gender,
      onChanged: ref.read(petFormDataProvider.notifier).setGender,
      items: items,
      itemsPerRow: 2,
    );
  }
}

class _IsNeuteredCheckboxWidget extends ConsumerWidget {
  const _IsNeuteredCheckboxWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNeutered = ref.watch(
      petFormDataProvider.select((s) => s.isNeutered),
    );
    final notifier = ref.read(petFormDataProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.centerLeft,
      child: TapEffect(
        effect: TapEffectType.none,
        onTap: () => notifier.setIsNeutered(!isNeutered),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: SC.smin(24) / 18,
              child: Checkbox(
                value: isNeutered,
                onChanged: (_) => notifier.setIsNeutered(!isNeutered),
                activeColor: AppColors.greenStrong1,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(
                  color: AppColors.greyCheckbox,
                  width: SC.smin(2),
                ),
              ),
            ),
            SizedBox(width: SC.sw(4)),
            Text(
              l10n.editPetNeuteredLabel,
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
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(petFormDataProvider.notifier);
    final async = ref.watch(petSpeciesProvider);

    final options = async.valueOrNull;
    if (options != null && options.isNotEmpty) {
      // Map danh sách master data thành TagItem
      final items = options
          .map(
            (o) => TagItem<String>(
              value: o.code,
              label: o.name,
              selectedBg: AC.greenSelectedBg,
              selectedBorder: AC.greenSelectedAccent,
              selectedText: AC.greenSelectedAccent,
            ),
          )
          .toList();

      final resolved = items.any((item) => item.value == selectedCode)
          ? selectedCode
          : items.first.value;

      return TagSelector<String>(
        value: resolved!,
        onChanged: notifier.setSpeciesCode,
        items: items,
      );
    }

    if (async.hasError) {
      return _defaultSelector(selectedCode, notifier, l10n);
    }

    // Khi đang load nhưng đã có cache thì nhánh trên đã trả; phần này xử lý
    // lúc cache rỗng hoặc lần đầu vào app để giữ UI ổn định.
    return _defaultSelector(selectedCode, notifier, l10n);
  }

  Widget _defaultSelector(
    String? selectedCode,
    PetFormDataNotifier notifier,
    AppLocalizations l10n,
  ) {
    final items = _fallbackItems(l10n);
    final resolved = selectedCode ?? items.first.value;
    return TagSelector<String>(
      value: resolved,
      onChanged: notifier.setSpeciesCode,
      items: items,
    );
  }

  List<TagItem<String>> _fallbackItems(AppLocalizations l10n) => [
    TagItem(
      value: 'dog',
      label: l10n.petFormSpeciesDog,
      selectedBg: AC.greenSelectedBg,
      selectedBorder: AC.greenSelectedAccent,
      selectedText: AC.greenSelectedAccent,
    ),
    TagItem(
      value: 'cat',
      label: l10n.petFormSpeciesCat,
      selectedBg: AC.greenSelectedBg,
      selectedBorder: AC.greenSelectedAccent,
      selectedText: AC.greenSelectedAccent,
    ),
  ];
}

// class _SelectBreedWidget extends ConsumerStatefulWidget {
//   const _SelectBreedWidget();

//   @override
//   ConsumerState<_SelectBreedWidget> createState() => _SelectBreedWidgetState();
// }

// class _SelectBreedWidgetState extends ConsumerState<_SelectBreedWidget> {
//   late final TextEditingController _ctrl;
//   @override
//   void initState() {
//     super.initState();
//     _ctrl = TextEditingController(
//       text: ref.read(petFormDataProvider.select((s) => s.breed)) ?? '',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final breedsAsync = ref.watch(petBreedProvider);
//     final notifier = ref.read(petFormDataProvider.notifier);
//     return breedsAsync.when(
//       loading: () =>
//           InputField(hintText: 'Giống (đang tải...)', controller: _ctrl),
//       error: (_, __) =>
//           InputField(hintText: 'Giống (lỗi tải)', controller: _ctrl),
//       data: (breeds) {
//         return InputField(
//           hintText: 'Giống',
//           controller: _ctrl,
//           onChanged: notifier.setBreed,
//         );
//       },
//     );
//   }
// }

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
    // ✅ Lắng nghe thay đổi breed trong form → cập nhật controller
    ref.listen<String?>(petFormDataProvider.select((s) => s.breed), (
      prev,
      next,
    ) {
      if (next != _breedController.text) {
        _breedController.text = next ?? '';
      }
    });

    final quickPicks = ref.watch(
      petBreedsProvider.select((s) => s.recentPetBreeds),
    );
    final breedsAsync = ref.watch(petBreedProvider);
    final speciesCode = ref.watch(
      petFormDataProvider.select((s) => s.speciesCode),
    );
    final l10n = AppLocalizations.of(context)!;
    final petFormNotifier = ref.read(petFormDataProvider.notifier);

    final breeds = breedsAsync.valueOrNull;
    final speciesAsync = ref.watch(petSpeciesProvider);
    final allSpecies = speciesAsync.valueOrNull ?? [];

    if (breeds != null) {
      // Lọc theo parentId từ species master data nếu có
      final selectedSpecies = PetSpeciesMasterData.fromCode(
        speciesCode ?? '',
        allSpecies,
      );

      final filteredBreeds = (selectedSpecies?.id != null)
          ? breeds.where((b) => b.parentId == selectedSpecies!.id).toList()
          : breeds;

      final allBreeds = filteredBreeds.map((b) => b.name).toList();

      return SelectTextField(
        fullOptions: allBreeds,
        quickOptions: quickPicks,
        hintText: l10n.editPetBreedHint,
        sheetTitle: l10n.editPetBreedSheetTitle,
        searchHint: l10n.editPetBreedSearchHint,
        allSectionText: l10n.editPetBreedAllSection,
        controller: _breedController,
        icon: null,
        onChanged: (selected) {
          if (selected != null && selected.trim().isNotEmpty) {
            ref.read(petBreedsProvider.notifier).addToRecent(selected);
          }
          petFormNotifier.setBreed(selected);
        },
      );
    }

    if (breedsAsync.hasError) {
      return SelectTextField(
        fullOptions: const [],
        quickOptions: quickPicks,
        hintText: l10n.editPetBreedErrorHint,
        sheetTitle: l10n.editPetBreedSheetTitle,
        searchHint: l10n.editPetBreedSearchHint,
        allSectionText: l10n.editPetBreedAllSection,
        controller: _breedController,
        icon: null,
        readOnly: true,
        onChanged: (_) {},
      );
    }

    return SelectTextField(
      fullOptions: const [],
      quickOptions: quickPicks,
      hintText: l10n.editPetBreedLoadingHint,
      sheetTitle: l10n.editPetBreedSheetTitle,
      searchHint: l10n.editPetBreedSearchHint,
      allSectionText: l10n.editPetBreedAllSection,
      controller: _breedController,
      icon: null,
      readOnly: true,
      onChanged: (_) {},
    );
  }
}

class _InputWeightField extends ConsumerStatefulWidget {
  const _InputWeightField();

  @override
  ConsumerState<_InputWeightField> createState() => _InputWeightFieldState();
}

class _InputWeightFieldState extends ConsumerState<_InputWeightField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    final weight = ref.read(petFormDataProvider.select((s) => s.weight));
    _ctrl = TextEditingController(text: weight?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Lắng nghe trong build, Riverpod cho phép
    ref.listen<double?>(petFormDataProvider.select((s) => s.weight), (
      prev,
      next,
    ) {
      final newText = next?.toString() ?? '';
      if (_ctrl.text != newText) _ctrl.text = newText;
    });

    final notifier = ref.read(petFormDataProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    return InputField(
      hintText: l10n.editPetWeightHint,
      controller: _ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (text) {
        final value = double.tryParse(text.trim().replaceAll(',', '.'));
        if (value != null) notifier.setWeight(value);
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class _InputHairColorField extends ConsumerStatefulWidget {
  const _InputHairColorField();

  @override
  ConsumerState<_InputHairColorField> createState() =>
      _InputHairColorFieldState();
}

class _InputHairColorFieldState extends ConsumerState<_InputHairColorField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    final color = ref.read(petFormDataProvider.select((s) => s.hairColor));
    _ctrl = TextEditingController(text: color ?? '');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(petFormDataProvider.select((s) => s.hairColor), (
      prev,
      next,
    ) {
      if (next != _ctrl.text) _ctrl.text = next ?? '';
    });

    final notifier = ref.read(petFormDataProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    return InputField(
      hintText: l10n.editPetHairColorLabel,
      controller: _ctrl,
      onChanged: notifier.setHairColor,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class _InputBirthdayField extends ConsumerWidget {
  const _InputBirthdayField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthdayIso = ref.watch(
      petFormDataProvider.select((s) => s.birthday),
    );
    DateTime? init;
    if (birthdayIso != null && birthdayIso.isNotEmpty) {
      try {
        init = DateTime.parse(birthdayIso);
      } catch (_) {}
    }
    return DateInputField(
      hintText: AppLocalizations.of(context)!.editPetBirthdayLabel,
      initialDate: init,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      onChanged: (v) => ref
          .read(petFormDataProvider.notifier)
          .setBirthday(
            v != null ? DateFormatConfig.dateOnlyToIsoLocal(v) : null,
          ),
    );
  }
}

class _InputAdoptedDayField extends ConsumerWidget {
  const _InputAdoptedDayField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adoptedIso = ref.watch(
      petFormDataProvider.select((s) => s.adoptedDate),
    );
    DateTime? init;
    if (adoptedIso != null && adoptedIso.isNotEmpty) {
      try {
        init = DateTime.parse(adoptedIso);
      } catch (_) {}
    }
    return DateInputField(
      hintText: AppLocalizations.of(context)!.editPetAdoptedLabel,
      initialDate: init,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      onChanged: (v) => ref
          .read(petFormDataProvider.notifier)
          .setAdoptedDay(
            v != null ? DateFormatConfig.dateOnlyToIsoLocal(v) : null,
          ),
    );
  }
}

class _InputDescriptionField extends ConsumerStatefulWidget {
  const _InputDescriptionField();

  @override
  ConsumerState<_InputDescriptionField> createState() =>
      _InputDescriptionFieldState();
}

class _InputDescriptionFieldState
    extends ConsumerState<_InputDescriptionField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    final desc = ref.read(petFormDataProvider.select((s) => s.description));
    _ctrl = TextEditingController(text: desc ?? '');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(petFormDataProvider.select((s) => s.description), (
      prev,
      next,
    ) {
      if (next != _ctrl.text) _ctrl.text = next ?? '';
    });

    final notifier = ref.read(petFormDataProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    return InputField(
      hintText: l10n.editPetInputHint,
      isLarge: true,
      controller: _ctrl,
      onChanged: notifier.setDescription,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class _InputAppearanceDetailField extends ConsumerStatefulWidget {
  const _InputAppearanceDetailField();

  @override
  ConsumerState<_InputAppearanceDetailField> createState() =>
      _InputAppearanceDetailFieldState();
}

class _InputAppearanceDetailFieldState
    extends ConsumerState<_InputAppearanceDetailField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    final detail = ref.read(
      petFormDataProvider.select((s) => s.appearanceDetail),
    );
    _ctrl = TextEditingController(text: detail ?? '');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(petFormDataProvider.select((s) => s.appearanceDetail), (
      prev,
      next,
    ) {
      if (next != _ctrl.text) _ctrl.text = next ?? '';
    });

    final notifier = ref.read(petFormDataProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    return InputField(
      hintText: l10n.editPetInputHint,
      isLarge: true,
      controller: _ctrl,
      onChanged: notifier.setAppearanceDetail,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
