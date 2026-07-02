import 'package:flutter/material.dart';
import 'package:capcat_doca/providers/pet_breed_repository_provider.dart';
import 'package:capcat_doca/providers/pet_species_repository_provider.dart';
import 'package:capcat_doca/screens/main/chat/chat_screen_new.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/edit-pet/edit_pet_screen.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/edit_pet_persona_screen.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/date_format_config.dart';
import 'package:capcat_doca/utils/navigation_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/button/action_button.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/input/expandable_text_container.dart';
import 'package:capcat_doca/widgets/text/whisper_bubble_widget.dart';
import 'package:capcat_doca/widgets/image/rectangle_cached_network_image.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart'
    show petByIdProvider;
import 'package:capcat_doca/providers/pet_form_providers.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:capcat_doca/services/chat_conversation_remote_service.dart';
import 'package:capcat_doca/services/pet_service.dart';
import 'package:capcat_doca/services/model/service_response.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';

class PetProfileScreen260202 extends ConsumerStatefulWidget {
  const PetProfileScreen260202({super.key, required this.petId});

  final String petId;

  @override
  ConsumerState<PetProfileScreen260202> createState() =>
      _PetProfileScreen260202State();
}

class _PetProfileScreen260202State
    extends ConsumerState<PetProfileScreen260202> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _onTapEditPet(BuildContext context, PetDetail pet) async {
    final ok = await _preloadPetMasterData(context);
    if (!context.mounted) return;
    if (!ok) {
      TO.show(context, AppLocalizations.of(context)!.petProfileLoadDataError);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderScope(
          overrides: [
            petFormDataProvider.overrideWith(
              () => PetFormDataNotifier(initialPet: pet),
            ),
          ],
          child: EditPetScreen(
            // action: EditPetScreenAction.edit,
            pet: pet,
            // isManual: true,
          ),
        ),
      ),
    );
  }

  void _onTapChat(BuildContext context, PetDetail pet) async {
    final response = await ChatConversationRemoteService.startConversation(
      petId: pet.id,
    );
    if (!context.mounted) return;

    if (!response.isSuccess || response.data == null) {
      if (response.errorCode == 'AI_AGENT_INFO_NOT_FOUND') {
        customCrossFadePush(context, EditPetPersonaScreen(petId: pet.id));
        return;
      }
      final message =
          response.message ??
          AppLocalizations.of(context)!.petProfileStartChatError;
      TO.show(context, message);
      return;
    }

    customCrossFadePush(context, ChatScreenNew(conversation: response.data!));
  }

  Future<bool> _preloadPetMasterData(BuildContext context) async {
    final ref = ProviderScope.containerOf(context);
    try {
      await Future.wait([
        ref.read(petBreedProvider.notifier).refresh(),
        ref.read(petSpeciesProvider.notifier).refresh(),
      ]);

      final breedsOk = (ref.read(petBreedProvider).value ?? []).isNotEmpty;
      final speciesOk = (ref.read(petSpeciesProvider).value ?? []).isNotEmpty;

      return breedsOk && speciesOk;
    } catch (e) {
      debugPrint('[preloadMasterData] error: $e');
      return false;
    }
  }

  void _onTapEditPersona(BuildContext context, PetDetail pet) {}

  // Future<bool> _preloadPersonaMasterData(BuildContext context) async {
  //   final ref = ProviderScope.containerOf(context);
  //   try {
  //     await Future.wait([
  //       ref.read(petPersonaTemplateProvider.notifier).refresh(),
  //       ref.read(petHobbyProvider.notifier).refresh(),
  //     ]);

  //     final personaOk =
  //         (ref.read(petPersonaTemplateProvider).value ?? []).isNotEmpty;
  //     final hobbyOk = (ref.read(petHobbyProvider).value ?? []).isNotEmpty;

  //     return personaOk && hobbyOk;
  //   } catch (e) {
  //     debugPrint('[preloadMasterData] error: $e');
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final PetDetail? petSummary = ref.watch(petByIdProvider(widget.petId));
    final topSafe = MediaQuery.of(context).padding.top;

    return FutureBuilder<ServiceResponse>(
      future: PetService.getPetDetail(widget.petId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomScaffold(
            body: SafeAreaTopOnly(
              child: Center(
                child: CircularProgressIndicator(color: AC.greenStrong1),
              ),
            ),
          );
        }

        PetDetail? pet = petSummary;
        if (snapshot.hasData && snapshot.data!.isSuccess) {
          pet = snapshot.data!.data as PetDetail;
        }

        if (pet == null) {
          return CustomScaffold(
            body: SafeAreaTopOnly(
              child: Center(
                child: Text(AppLocalizations.of(context)!.petProfileNotFound),
              ),
            ),
          );
        }

        final screenHeight = MediaQuery.of(context).size.height;
        final minChildSize =
            1 - (SC.sh(112) + topSafe) / screenHeight; // top at 112
        final maxChildSize = (screenHeight - SC.sh(16)) / screenHeight;

        return _PetProfileContent(
          pet: pet,
          onTapEditPet: () => _onTapEditPet(context, pet!),
          onTapChat: () => _onTapChat(context, pet!),
          onTapEditPersona: () => _onTapEditPersona(context, pet!),
          onTapQr: () {},
          onTapShield: () {},
          sheetController: _sheetController,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
//  PHẦN NỘI DUNG CHÍNH
// ---------------------------------------------------------------------------

class _PetProfileContent extends StatelessWidget {
  final PetDetail pet;
  final VoidCallback onTapQr;
  final VoidCallback onTapEditPet;
  final VoidCallback onTapChat;
  final VoidCallback onTapEditPersona;
  final VoidCallback onTapShield;
  final DraggableScrollableController sheetController;
  final double minChildSize;
  final double maxChildSize;
  const _PetProfileContent({
    required this.pet,
    required this.onTapEditPet,
    required this.onTapChat,
    required this.onTapEditPersona,
    required this.onTapQr,
    required this.onTapShield,
    required this.sheetController,
    required this.minChildSize,
    required this.maxChildSize,
  });

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;
    return CustomScaffold(
      backgroundColor: AC.greenStrong2,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            // White background section (draggable)
            Positioned.fill(
              child: Builder(
                builder: (context) {
                  return DraggableScrollableSheet(
                    controller: sheetController,
                    initialChildSize: minChildSize,
                    minChildSize: minChildSize,
                    maxChildSize: maxChildSize,
                    snap: false,
                    builder: (context, scrollController) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(36),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              bottom: MQ.bottomPadding(context),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              padding: EdgeInsets.fromLTRB(
                                SC.sw(24),
                                0,
                                SC.sw(24),
                                0,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: SC.sh(16)),
                                  _HeaderSection(pet: pet),
                                  SizedBox(height: SC.sh(24)),
                                  _DescriptionSection(pet: pet),
                                  SizedBox(height: SC.sh(24)),
                                  _StatsSection(pet: pet),
                                  SizedBox(height: SC.sh(24)),
                                  const _ActionButtonsSection(),
                                  SizedBox(height: SC.sh(24)),
                                  _AppearanceDetailsSection(
                                    petAppearanceDetails:
                                        pet.appearanceDetail ?? '',
                                  ),
                                  SizedBox(height: SC.sh(24)),
                                  _ImportantDatesSection(
                                    petBirthDay: pet.birthDate,
                                    petAdoptedDay: pet.adoptedDate,
                                    petAge: pet.age,
                                  ),
                                  SizedBox(height: SC.sh(24)),
                                  _PersonaSection(
                                    pet: pet,
                                    onTapEditPersona: onTapEditPersona,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: -SC.sh(24),
                            // left: SC.sw(24),
                            child: _AvatarWithWhisper(pet: pet),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: sheetController,
                builder: (context, _) {
                  final size = sheetController.isAttached
                      ? sheetController.size
                      : minChildSize;
                  final current = (size == 0) ? minChildSize : size;
                  final denom = (maxChildSize - minChildSize) * 0.75;
                  final t = denom <= 0
                      ? 1.0
                      : ((current - minChildSize) / denom).clamp(0.0, 1.0);
                  final bgColor = AC.white.withOpacity(t);
                  return _ScreenHeader(
                    onTapShare: () {},
                    onTapQr: () {
                      TO.show(
                        context,
                        AppLocalizations.of(
                          context,
                        )!.petProfileFeatureComingSoon,
                      );
                    },
                    onTapChat: onTapChat,
                    backgroundColor: bgColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  APP HEADER
// ---------------------------------------------------------------------------
class _ScreenHeader extends StatelessWidget {
  final VoidCallback onTapShare;
  final VoidCallback onTapQr;
  final VoidCallback onTapChat;
  // final VoidCallback onTapEdit;
  // final VoidCallback onTapShield;

  const _ScreenHeader({
    required this.onTapShare,
    required this.onTapQr,
    required this.onTapChat,
    this.backgroundColor = Colors.transparent,
    // required this.onTapEdit,
    // required this.onTapShield,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          SC.sw(16),
          MediaQuery.of(context).padding.top + SC.sh(8),
          SC.sw(16),
          SC.sh(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TapEffect(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/icons/arrow-backward-white.png',
                height: SC.sh(20),
              ),
            ),
            Row(
              children: [
                // TapEffect(
                //   onTap: onTapQr,
                //   child: Image.asset(
                //     'assets/icons/pet-profile-qr-white.png',
                //     height: SC.sh(24),
                //   ),
                // ),
                // SizedBox(width: SC.sw(20)),
                // TapEffect(
                //   onTap: onTapEdit,
                //   child: Image.asset(
                //     'assets/icons/pet-profile-edit-pet.png',
                //     height: SC.sh(24),
                //   ),
                // ),
                // SizedBox(width: SC.sw(20)),
                // TapEffect(
                //   onTap: onTapShield,
                //   child: Image.asset(
                //     'assets/icons/pet-profile-shield.png',
                //     height: SC.sh(24),
                //   ),
                // ),
                TapEffect(
                  onTap: onTapShare,
                  child: Image.asset(
                    'assets/icons/pet-profile-header-share.png',
                    height: SC.sh(32),
                  ),
                ),
                SizedBox(width: SC.sw(8)),
                TapEffect(
                  onTap: onTapQr,
                  child: Image.asset(
                    'assets/icons/pet-profile-header-qr.png',
                    height: SC.sh(32),
                  ),
                ),
                SizedBox(width: SC.sw(8)),
                TapEffect(
                  onTap: onTapChat,
                  child: Image.asset(
                    'assets/icons/pet-profile-header-chat.png',
                    height: SC.sh(32),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  AVATAR + MOOD
// ---------------------------------------------------------------------------
class _AvatarWithWhisper extends StatelessWidget {
  final PetDetail pet;
  const _AvatarWithWhisper({required this.pet});

  @override
  Widget build(BuildContext context) {
    final outerSize = SC.smin(80);
    final whitePadding = SC.smin(4);
    final orangePadding = SC.smin(2);
    final imageSize = outerSize - 2 * whitePadding - 2 * orangePadding;
    return Padding(
      padding: EdgeInsets.only(left: SC.sw(24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(height: SC.sh(4)),
              Container(
                width: outerSize,
                height: outerSize,
                padding: EdgeInsets.fromLTRB(
                  whitePadding,
                  whitePadding,
                  whitePadding,
                  whitePadding,
                ),
                decoration: BoxDecoration(
                  color: AC.white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 15,
                      offset: Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    // padding: EdgeInsets.all(orangePadding),
                    decoration: BoxDecoration(
                      color: AC.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AC.amberMomentAccent,
                        width: orangePadding,
                      ),
                    ),
                    child: CircleCachedNetworkImage(
                      imageUrl: pet.avatarUrl,
                      size: imageSize,
                      subject: ImageSubject.pet,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: SC.sw(4)),
          // pet.whisper?.isNotEmpty == true
          //     ? WhisperBubbleWidget(text: pet.whisper!)
          //     : Container(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  HEADER: NAME + BREED + CHAT
// ---------------------------------------------------------------------------
class _HeaderSection extends StatelessWidget {
  final PetDetail pet;
  // final VoidCallback onTapChat;
  // const _HeaderSection({required this.pet, required this.onTapChat});
  const _HeaderSection({required this.pet});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: SC.sw(96)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    pet.name,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: SC.sf(24),
                      fontWeight: FontWeight.w700,
                      color: AC.blackText6,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: SC.sw(8)),
                  TapEffect(
                    // onTap: onTapEdit,
                    child: Image.asset(
                      'assets/icons/pet-profile-edit-name.png',
                      height: SC.sh(16),
                    ),
                  ),
                ],
              ),

              Text(
                pet.breed,
                style: TextStyle(
                  // fontFamily: 'Noto Sans',
                  fontSize: SC.sf(14),
                  color: AC.greyText4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ],
          ),
        ),
        // TapEffect(
        //   onTap: onTapChat,
        //   child: Image.asset(
        //     'assets/icons/pet-profile-chat.png',
        //     height: SC.sh(48),
        //   ),
        // ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
//  DESCRIPTION SECTION
// ---------------------------------------------------------------------------
class _DescriptionSection extends StatelessWidget {
  final PetDetail pet;
  const _DescriptionSection({required this.pet});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.petProfileShortDesc,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(16),
            height: 1.5,
            color: AC.blackText5,
          ),
        ),
        SizedBox(height: SC.sh(8)),
        Text(
          pet.description?.isNotEmpty == true
              ? pet.description!
              : l10n.petProfileNoDesc,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w400,
            fontSize: SC.sf(14),
            height: 1.4,
            color: AC.slateSecondaryText,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
//  STATS SECTION
// ---------------------------------------------------------------------------
class _StatsSection extends StatelessWidget {
  final PetDetail pet;
  const _StatsSection({required this.pet});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            iconWidget: Image.asset(
              pet.gender == PetGender.male
                  ? 'assets/icons/male-simple.png'
                  : 'assets/icons/female-simple.png',
              width: SC.smin(24),
            ),
            title: l10n.petProfileGender,
            value: pet.gender.label,
            bgColor: pet.gender == PetGender.male
                ? AC.blueInfoBg
                : AC.pinkSoftBg,
          ),
        ),
        SizedBox(width: SC.sw(8)),
        Expanded(
          child: _StatCard(
            iconWidget: Image.asset(
              'assets/icons/weight.png',
              width: SC.smin(24),
            ),
            title: l10n.petProfileWeight,
            value: pet.weight != null ? '${pet.weight} kg' : '-',
            bgColor: AC.yellowToolPanel,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String value;
  final Color bgColor;

  const _StatCard({
    required this.iconWidget,
    required this.title,
    required this.value,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: SC.sh(8), horizontal: SC.sw(8)),
      height: SC.sh(62),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: SC.smin(46),
            alignment: Alignment.center,
            child: iconWidget,
          ),
          SizedBox(width: SC.sw(8)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: SC.sf(12),
                  color: AC.greyText5,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: SC.sf(16),
                  fontWeight: FontWeight.w700,
                  color: AC.blackText5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  ACTION BUTTONS
// ---------------------------------------------------------------------------
class _ActionButtonsSection extends StatelessWidget {
  const _ActionButtonsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        ActionButton(
          text: l10n.petProfileShareProfile,
          onTap: () {
            ToastOverlay.show(
              context,
              AppLocalizations.of(context)!.petProfileFeatureComingSoon,
            );
          },
          borderColor: AC.greenChipBorder,
          color: AC.greenBorderLightOverlay,
          textColor: AC.blackText3,
          leadingIcon: Image.asset(
            'assets/icons/pet-profile-qr-black.png',
            width: SC.smin(20),
          ),
        ),
        // _RoundButton(
        //   iconWidget: Icon(Icons.qr_code, color: AC.blackText3),
        //   text: 'Chia sẻ hồ sơ',
        //   borderColor: AC.greenChipBorder,
        //   bgColor: AC.greenBorderLightOverlay,
        //   textColor: AC.blackText3,
        // ),
        SizedBox(height: SC.sh(8)),
        ActionButton(
          text: l10n.petProfileLostMode,
          onTap: () {
            ToastOverlay.show(
              context,
              AppLocalizations.of(context)!.petProfileFeatureComingSoon,
            );
          },
          borderColor: AC.redRequiredMark,
          color: AC.redAlertOverlay,
          textColor: AC.redRequiredMark,
          leadingIcon: Image.asset(
            'assets/icons/pet-profile-megaphone.png',
            width: SC.smin(20),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
//  APPEARANCE DETAILS
// ---------------------------------------------------------------------------
class _AppearanceDetailsSection extends StatelessWidget {
  const _AppearanceDetailsSection({required this.petAppearanceDetails});
  final String petAppearanceDetails;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ExpandableTextContainer(
      title: l10n.petProfileAppearanceTitle,
      body: petAppearanceDetails,
    );
  }
}

// ---------------------------------------------------------------------------
//  IMPORTANT DATES
// ---------------------------------------------------------------------------
class _ImportantDatesSection extends StatelessWidget {
  const _ImportantDatesSection({
    required this.petBirthDay,
    required this.petAdoptedDay,
    required this.petAge,
  });

  final String? petBirthDay;
  final String? petAdoptedDay;
  final int? petAge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.petProfileImportantDatesTitle,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(16),
            color: AC.blackText5,
          ),
        ),
        SizedBox(height: SC.sh(16)),
        _ImportantDatesCard(
          iconWidget: Image.asset(
            'assets/icons/birthday.png',
            width: SC.sw(20),
          ),
          title: l10n.petProfileBirthday,
          body: petBirthDay != null
              ? DateFormatConfig.isoToLongDisplay(petBirthDay!)
              : '-',
        ),

        // ✅ Chỉ hiển thị khi petAdoptedDay != null
        if (petAdoptedDay != null) ...[
          SizedBox(height: SC.sh(8)),
          const Divider(color: AC.greyLine2),
          SizedBox(height: SC.sh(8)),
          _ImportantDatesCard(
            iconWidget: Image.asset(
              'assets/icons/adopted.png',
              width: SC.sw(20),
            ),
            title: l10n.petProfileAdopted,
            body: DateFormatConfig.isoToLongDisplay(petAdoptedDay!),
          ),
        ],
      ],
    );
  }
}

class _ImportantDatesCard extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String body;

  const _ImportantDatesCard({
    required this.iconWidget,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SC.sh(46),
      child: Row(
        children: [
          Container(
            height: SC.smin(46),
            width: SC.smin(46),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(168, 216, 185, 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: iconWidget,
          ),
          SizedBox(width: SC.sw(10)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w400,
                        fontSize: SC.sf(14),
                        color: AC.greyText5,
                      ),
                    ),
                    Text(
                      body,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600,
                        fontSize: SC.sf(14),
                        color: AC.blackText5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonaSection extends StatelessWidget {
  final PetDetail pet;
  final VoidCallback? onTapEditPersona;

  const _PersonaSection({required this.pet, this.onTapEditPersona});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final persona = pet.persona;
    if (persona == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.petProfilePersonaTitle,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(16),
            color: AC.blackText5,
          ),
        ),
        SizedBox(height: SC.sh(16)),

        // Persona info card
        Container(
          width: double.infinity,
          height: SC.sh(76),
          padding: EdgeInsets.symmetric(
            // vertical: SC.sh(8),
            horizontal: SC.sw(8),
          ),
          decoration: BoxDecoration(
            color: AC.greenStrong1,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: SC.smin(60),
                    decoration: BoxDecoration(
                      color: AC.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: RectangleCachedNetworkImage(
                      imageUrl: persona.iconUrl,
                      width: SC.smin(60),
                      height: SC.smin(60),
                      radius: SC.smin(16),
                      fit: BoxFit.contain,
                      subject: ImageSubject.others,
                    ),
                  ),
                  SizedBox(width: SC.sw(8)),
                  Text(
                    persona.name,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      fontSize: SC.sf(16),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              if (onTapEditPersona != null)
                TapEffect(
                  onTap: onTapEditPersona,
                  child: Image.asset(
                    'assets/icons/pet-profile-edit-pet.png',
                    width: SC.smin(24),
                    color: AC.white,
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: SC.sh(24)),

        // Personality groups
        _TagGroup(title: l10n.petProfilePersonaTraits, tags: persona.traits),
        SizedBox(height: SC.sh(16)),
        _TagGroup(title: l10n.petProfilePersonaTone, tags: persona.tones),
        SizedBox(height: SC.sh(16)),
        _TagGroup(title: l10n.petProfilePersonaStyle, tags: persona.styles),
      ],
    );
  }
}

class _TagGroup extends StatelessWidget {
  final String title;
  final List<String> tags;
  const _TagGroup({required this.title, required this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(12),
            color: Colors.black,
          ),
        ),
        SizedBox(height: SC.sh(8)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map(
                (t) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SC.sw(16),
                    vertical: SC.sh(4),
                  ),
                  decoration: BoxDecoration(
                    color: AC.greyTab1,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    t,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: SC.sf(12),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
