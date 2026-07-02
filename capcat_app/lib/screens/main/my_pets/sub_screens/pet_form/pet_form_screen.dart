import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/enums/edit_pet_screen_action.dart';
import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/models/pet_species_master_data.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart';
import 'package:capcat_doca/providers/pet_breed_repository_provider.dart';
import 'package:capcat_doca/providers/pet_form_providers.dart';
import 'package:capcat_doca/providers/pet_hobby_repository_provider.dart';
import 'package:capcat_doca/providers/pet_persona_template_provider.dart';
import 'package:capcat_doca/providers/pet_species_repository_provider.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/sheets/pet_form_1st_sheet.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/sheets/pet_form_1st_waiting_sheet.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/sheets/pet_form_2nd_sheet.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/sheets/pet_form_3rd_sheet_auto.dart';
import 'package:capcat_doca/services/pet_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/utils/transition_config.dart';
import 'package:capcat_doca/widgets/button/action_button.dart';
import 'package:capcat_doca/widgets/keyboard_dismisser.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:capcat_doca/widgets/shared/animated_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class PetFormScreen extends ConsumerStatefulWidget {
  const PetFormScreen({
    super.key,
    required this.action,
    required this.pet,
    required this.isManual,
  });

  final EditPetScreenAction action;
  final PetDetail? pet;
  final bool isManual;

  @override
  ConsumerState<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends ConsumerState<PetFormScreen> {
  late final PageController _pageController;
  int _currentPageIndex = 0;
  late String headerSubtitle;
  bool _isFirstWaitingSheetVisible = false;

  List<Map<String, dynamic>> get autoSheets {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        'sheet': Stack(
          children: [
            PetForm1stSheet(
              actionButton: ActionButton(
                text: l10n.commonContinue,
                trailingIcon: Image.asset('assets/icons/ab-chevron-right.png'),
                onTap: _onFirstSheetTapContinue,
              ),
            ),
            if (_isFirstWaitingSheetVisible) const PetForm1stWaitingSheet(),
          ],
        ),
        'subTitle': l10n.petFormStepGeneral,
      },
      {
        'sheet': PetForm2ndSheet(
          actionButton: ActionButton(
            text: l10n.petFormConfirmAndCreate,
            trailingIcon: Image.asset('assets/icons/ab-chevron-right.png'),
            onTap: _onSecondSheetTapConfirm,
          ),
        ),
        'subTitle': l10n.petFormStepAdditional,
      },
      {
        'sheet': PetForm3rdSheetAuto(
          actionButton: ActionButton(
            text: l10n.petFormSave,
            trailingIcon: Image.asset('assets/icons/ab-check.png'),
            onTap: _onThirdSheetTapSave,
          ),
        ),
        'subTitle': l10n.petFormStepPersona,
      },
      // {
      //   'sheet': PetForm4thSheet(
      //     leftButton: _BackButton(onTap: _onChildTapBack),
      //     rightButton: _SaveButton(onTap: _onChildTapSave),
      //   ),
      //   'subTitle': 'Thông tin vòng cổ CapCat',
      // },
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      if (_pageController.page == 1.0 && _isFirstWaitingSheetVisible) {
        setState(() {
          _isFirstWaitingSheetVisible = false;
        });
      }
    });
  }

  bool _didInitDependencies = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitDependencies) {
      _didInitDependencies = true;
      _updateHeaderSubtitle();
    }
  }

  @override
  void dispose() {
    _isFirstWaitingSheetVisible = false;
    // ref.invalidate(petMasterDataReadyProvider);
    // ref.invalidate(petAnalysisDoneProvider);
    _pageController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    TO.show(context, message);
  }

  bool get _shouldResizeWithKeyboard {
    switch (_currentPageIndex) {
      case 0:
        return false;
      case 1:
        return false;
      case 2:
        return false;
      default:
        return false;
    }
  }

  bool _validateSheetInput() {
    final formData = ref.read(petFormDataProvider);
    final l10n = AppLocalizations.of(context)!;
    switch (_currentPageIndex) {
      case 0:
        if (formData.name == null) {
          _showMessage(l10n.petFormNameRequired);
          return false;
        }
        break;

      case 1:
        if (formData.breed == null) {
          _showMessage(l10n.petFormBreedRequired);
          return false;
        }
        break;

      case 2:
        if (formData.personaTemplateId == null) {
          _showMessage(l10n.petFormPersonaRequired);
          return false;
        }
        break;
    }
    return true;
  }

  void _updateHeaderSubtitle() {
    headerSubtitle = autoSheets[_currentPageIndex]['subTitle'];
  }

  // void _onChildTapSave() {
  //   final formData = ref.read(petFormDataProvider);
  //   final listNotifier = ref.read(listPetDetailProvider.notifier);

  //   final newPet = PetDetail.fromForm(
  //     formData,
  //     id: widget.action == EditPetScreenAction.edit ? widget.pet!.id : null,
  //   );

  //   listNotifier.update((state) {
  //     final newList = [...state];

  //     if (widget.action == EditPetScreenAction.create) {
  //       //--Create new pet
  //       newList.add(newPet);
  //     } else {
  //       //--Update pet
  //       final index = newList.indexWhere((p) => p.id == widget.pet!.id);

  //       if (index == -1) {
  //         //--If pet doesn't exist
  //         newList.add(newPet);
  //       } else {
  //         newList[index] = widget.pet!.copyWith(
  //           id: widget.pet!.id,
  //           name: newPet.name,
  //           avatarUrl: newPet.avatarUrl,
  //           gallery: newPet.gallery,
  //           gender: newPet.gender,
  //           species: newPet.species,
  //           breed: newPet.breed,
  //           hairColor: newPet.hairColor,
  //           weight: newPet.weight,
  //           birthday: newPet.birthday,
  //           adoptedDay: newPet.adoptedDay,
  //           description: newPet.description,
  //           appearanceDetail: newPet.appearanceDetail,
  //           personaTemplateId: newPet.personaTemplateId,
  //           selfTerm: newPet.selfTerm,
  //           ownerTerm: newPet.ownerTerm,
  //           isNeutered: newPet.isNeutered,
  //         );
  //       }
  //     }

  //     return newList;
  //   });

  //   //--Reset
  //   ref.invalidate(petFormDataProvider);

  //   //--To root screen (My Pets screen)
  //   Navigator.of(context).popUntil((route) => route.isFirst);
  // }

  Future<bool> _preloadMasterData() async {
    try {
      //--Run all the 4 at the same time
      await Future.wait([
        ref.read(petPersonaTemplateProvider.notifier).refresh(),
        ref.read(petHobbyProvider.notifier).refresh(),
        ref.read(petBreedProvider.notifier).refresh(),
        ref.read(petSpeciesProvider.notifier).refresh(),
      ]);

      //--Verify data
      final personasOk =
          (ref.read(petPersonaTemplateProvider).value ?? []).isNotEmpty;
      final hobbiesOk = (ref.read(petHobbyProvider).value ?? []).isNotEmpty;
      final breedsOk = (ref.read(petBreedProvider).value ?? []).isNotEmpty;
      final speciesOk = (ref.read(petSpeciesProvider).value ?? []).isNotEmpty;

      return personasOk && hobbiesOk && breedsOk && speciesOk;
    } catch (e) {
      debugPrint('[preloadMasterData] error: $e');
      return false;
    }
  }

  void _onFirstSheetTapContinue() {
    bool isValidInput = _validateSheetInput();
    if (!isValidInput) {
      return;
    }

    setState(() {
      _isFirstWaitingSheetVisible = true;
    });

    Future.microtask(() async {
      final ok = await _preloadMasterData();
      if (!mounted) return;

      if (!ok) {
        TO.show(context, AppLocalizations.of(context)!.petFormMasterDataError);
        setState(() {
          _isFirstWaitingSheetVisible = false;
        });
        return;
      }

      final imageUrl = ref.read(petFormDataProvider).avatarUrl;
      final name = ref.read(petFormDataProvider).name;
      final gender = ref.read(petFormDataProvider).gender;
      final isSterilized = ref.read(petFormDataProvider).isNeutered;

      if (imageUrl == null || name == null) {
        throw Exception('Missing required data to analyze pet avatar');
      }

      final serviceResponse = await PetService.getPetAvatarAnalyses(
        imageUrl: imageUrl,
        name: name,
        gender: gender.value,
        isSterilized: isSterilized,
      );

      if (!mounted) return;

      if (!serviceResponse.isSuccess) {
        TO.show(
          context,
          (serviceResponse.message?.trim().isNotEmpty == true)
              ? serviceResponse.message!
              : AppLocalizations.of(context)!.petFormMasterDataError,
        );
        setState(() {
          _isFirstWaitingSheetVisible = false;
        });
        return;
      }

      final data = serviceResponse.data;
      debugPrint('[petFormScreen_getPetAvatarAnalyses]${data.toString()}');

      final Map<String, dynamic> dataModeration = data['moderation'];
      final isPet = dataModeration['is_pet'];
      final safetyFlagged = dataModeration['safety_flagged'];
      final rejected = dataModeration['rejected'];
      final description = dataModeration['description'];

      if (rejected == true) {
        TO.show(
          context,
          (serviceResponse.message?.trim().isNotEmpty == true)
              ? serviceResponse.message!
              : AppLocalizations.of(context)!.petFormTryAnotherImage,
        );
        setState(() {
          _isFirstWaitingSheetVisible = false;
        });
        return;
      }

      final Map<String, dynamic> dataExtraction = data['extraction'];

      final notifier = ref.read(petFormDataProvider.notifier);
      final allSpecies = ref.read(petSpeciesProvider).value ?? [];
      final speciesOpt = PetSpeciesMasterData.fromCode(
        dataExtraction['species'],
        allSpecies,
      );
      if (speciesOpt != null) {
        notifier.setSpeciesCode(speciesOpt.code);
      }
      // notifier.setSpecies(PetSpeciesOption.fromCode(dataExtraction['species']));
      notifier.setBreed(dataExtraction['breed']);
      notifier.setHairColor(dataExtraction['color']);
      notifier.setDescription(dataExtraction['bio']);
      notifier.setAppearanceDetail(dataExtraction['description']);
      notifier.setWeight(dataExtraction['weight'] * 1.0);

      ref.read(petAnalysisDoneProvider.notifier).state = true;
      await Future.delayed(const Duration(milliseconds: 300));

      final nextPage = _currentPageIndex + 1;
      if (!mounted) return;
      setState(() {
        _currentPageIndex = nextPage;
      });
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: TransitionConfig.durationShort),
        curve: Curves.easeInOut,
      );
      _updateHeaderSubtitle();
    });
  }

  void _onSecondSheetTapConfirm() async {
    final form = ref.read(petFormDataProvider);

    if (form.birthday == null || form.birthday!.isEmpty) {
      TO.show(context, AppLocalizations.of(context)!.petFormBirthdayRequired);
      return;
    }

    final serviceResponse = await PetService.createPet(form);
    if (!mounted) return;

    if (serviceResponse.isSuccess) {
      final petData = serviceResponse.data;
      debugPrint("Pet created: $petData");

      final String id = petData['id'];
      final formNotifier = ref.read(petFormDataProvider.notifier);
      formNotifier.setId(id);

      // Upsert vào local list
      final newPet = PetDetail.fromForm(form, id: id);
      await ref.read(listPetDetailProvider.notifier).upsertPet(newPet);
      if (!mounted) return;

      TO.show(context, AppLocalizations.of(context)!.petFormCreateSuccess);
      // TODO: l10n key for pet creation success already exists? Use petFormCreateSuccess if available.

      final nextPage = _currentPageIndex + 1;
      setState(() {
        _currentPageIndex = nextPage;
      });
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: TransitionConfig.durationShort),
        curve: Curves.easeInOut,
      );
      _updateHeaderSubtitle();
    } else {
      debugPrint("Create pet failed: ${serviceResponse.message}");
      _showMessage(
        (serviceResponse.message?.trim().isNotEmpty == true)
            ? serviceResponse.message!
            : AppLocalizations.of(context)!.petFormGenericError,
      );
    }
  }

  void _onThirdSheetTapSave() async {
    final form = ref.read(petFormDataProvider);

    final selfTerm = form.petTerm?.trim() ?? '';
    if (selfTerm.isEmpty) {
      TO.show(context, AppLocalizations.of(context)!.petFormCallPetRequired);
      return;
    }

    final ownerTerm = form.ownerTerm?.trim() ?? '';
    if (ownerTerm.isEmpty) {
      TO.show(context, AppLocalizations.of(context)!.petFormCallOwnerRequired);
      return;
    }

    final hobbies = form.hobby ?? [];
    if (hobbies.isEmpty) {
      TO.show(context, AppLocalizations.of(context)!.petFormHobbyRequired);
      return;
    }

    final serviceResponse = await PetService.createPetAiAgent(form);
    if (!mounted) return;

    if (serviceResponse.isSuccess) {
      final petData = serviceResponse.data;
      debugPrint("CreatePetAiAgent: $petData");

      TO.show(
        context,
        AppLocalizations.of(context)!.petFormCreatePersonaSuccess,
      );

      await ref
          .read(listPetDetailProvider.notifier)
          .updatePetFields(
            petId: form.id!,
            personaTemplateId: form.personaTemplateId,
            selfTerm: form.petTerm,
            ownerTerm: form.ownerTerm,
            hobby: form.hobby,
          );

      if (!mounted) return;
      _resetAndExit();
    } else {
      debugPrint("Create pet AI agent failed: ${serviceResponse.message}");
      _showMessage(
        (serviceResponse.message?.trim().isNotEmpty == true)
            ? serviceResponse.message!
            : AppLocalizations.of(context)!.petFormGenericError,
      );
    }
  }

  void _resetAndExit() {
    ref.invalidate(petFormDataProvider);
    ref.invalidate(petMasterDataReadyProvider);
    ref.invalidate(petAnalysisDoneProvider);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AssistantVisibilityScope.hide(
      child: KeyboardDismisser(
        child: CustomScaffold(
          backgroundColor: AppColors.white,
          resizeToAvoidBottomInset: _shouldResizeWithKeyboard,

          body: SafeAreaTopOnly(
            child: Column(
              children: [
                //--Header with page number
                Stack(
                  children: [
                    CustomAppHeader(
                      color: AC.white,
                      title: widget.action == EditPetScreenAction.create
                          ? l10n.petFormLandingTitle
                          : l10n.petFormConfirmAndCreate,
                      // subtitle: headerSubtitle,
                      leftActionIcon: 'assets/icons/main-x.png',
                      showBottomLine: false,
                      onTapLeftAction: () {
                        _resetAndExit();
                      },
                      subtitleWidget: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        child: Text(
                          headerSubtitle,
                          key: ValueKey(headerSubtitle),
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w500,
                            fontSize: SC.sf(14),
                            height: 20 / 14,
                            color: AC.greyText5,
                          ),
                        ),
                      ),
                    ),

                    //--Page number
                    Positioned(
                      right: SC.sw(24),
                      child: Container(
                        height: SC.sh(66),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                              switchInCurve: Curves.easeInOut,
                              switchOutCurve: Curves.easeInOut,
                              child: Text(
                                '${_currentPageIndex + 1}',
                                key: ValueKey(_currentPageIndex),
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w600,
                                  fontSize: SC.sf(12),
                                  color: AC.blackText5,
                                ),
                              ),
                            ),
                            Text(
                              '/3',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w400,
                                fontSize: SC.sf(12),
                                color: AC.greyText6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedProgressBar(
                  currentStep: _currentPageIndex + 1,
                  totalSteps: 3,
                ),

                //--Page view
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {},
                    children: [
                      autoSheets[0]['sheet'],
                      autoSheets[1]['sheet'],
                      autoSheets[2]['sheet'],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _BackButton extends StatelessWidget {
//   const _BackButton({required this.onTap});

//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomRight,
//       child: ActionButton(
//         text: 'Quay lại',
//         isSmall: true,
//         color: Colors.transparent,
//         borderColor: Colors.transparent,
//         textColor: AC.greyText4,
//         leadingIcon: Image.asset('assets/icons/arrow-left-pet-form.png'),
//         onTap: () {
//           onTap();
//         },
//       ),
//     );
//   }
// }

// class _ContinueButton extends StatelessWidget {
//   const _ContinueButton({required this.onTap});
//   final VoidCallback onTap;
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomRight,
//       child: ActionButton(
//         text: 'Tiếp tục',
//         isSmall: true,
//         trailingIcon: Image.asset('assets/icons/arrow-right-pet-form.png'),
//         onTap: () {
//           onTap();
//         },
//       ),
//     );
//   }
// }

// class _SaveButton extends StatelessWidget {
//   const _SaveButton({required this.onTap});
//   final VoidCallback onTap;
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomRight,
//       child: ActionButton(
//         text: 'Lưu lại',
//         isSmall: true,
//         trailingIcon: Image.asset('assets/icons/check-save-pet-form.png'),
//         onTap: () {
//           onTap();
//         },
//       ),
//     );
//   }
// }
