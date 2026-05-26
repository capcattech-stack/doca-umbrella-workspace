import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_mock_app/providers/pet_breed_repository_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_species_repository_provider.dart';
import 'package:flutter_chat_mock_app/screens/main/chat/chat_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/edit-pet/edit_pet_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_form/edit_pet_persona_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_profile/editor_sheets/brief_editor_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_profile/editor_sheets/name_avatar_editor_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_profile/editor_sheets/other_data_editor_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_profile/editor_sheets/life_stage_sheet.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/date_format_config.dart';
import 'package:flutter_chat_mock_app/utils/navigation_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/input/expandable_text_container.dart';
import 'package:flutter_chat_mock_app/widgets/image/rectangle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/widgets/viewer/all_pictures_screen.dart';
import 'package:flutter_chat_mock_app/providers/list_pet_detail_provider.dart'
    show petByIdProvider;
import 'package:flutter_chat_mock_app/providers/pet_form_providers.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/services/chat_conversation_remote_service.dart';
import 'package:flutter_chat_mock_app/services/pet_service.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_chat_mock_app/widgets/qr/qr_share_sheet.dart';
import 'package:flutter_chat_mock_app/widgets/loading/text_loading_indicator.dart';
import 'editor_sheets/birth_date_editor_sheet.dart';
import 'editor_sheets/identity_editor_screen.dart';

class PetProfileScreen extends ConsumerStatefulWidget {
  const PetProfileScreen({super.key, required this.petId});

  final String petId;

  @override
  ConsumerState<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends ConsumerState<PetProfileScreen> {
  _PetProfileData? _cachedData;
  bool _isLoading = true;
  final ValueNotifier<double> _sheetExtent = ValueNotifier<double>(0);

  Future<_PetProfileData?> _loadPetData(PetDetail? petSummary) async {
    final detailResp = await PetService.getPetDetail(widget.petId);
    PetDetail? pet = petSummary;
    if (detailResp.isSuccess && detailResp.data != null) {
      pet = detailResp.data as PetDetail;
      debugPrint(
        '[PetProfileScreen] parsed lifeStage: key=${pet.lifeStage?.key}, '
        'label=${pet.lifeStage?.label}, start=${pet.lifeStage?.startMonth}, '
        'end=${pet.lifeStage?.endMonth}, short=${pet.lifeStage?.detail?.short}',
      );
    }

    final imagesResp = await PetService.getPetImages(widget.petId);
    final images = (imagesResp.isSuccess && imagesResp.data != null)
        ? List<String>.from(imagesResp.data as List)
        : <String>[];

    if (pet == null) return null;
    return _PetProfileData(pet: pet, images: images);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final PetDetail? summary = ref.read(petByIdProvider(widget.petId));
      final data = await _loadPetData(summary);
      if (!mounted) return;
      setState(() {
        _cachedData = data;
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _sheetExtent.dispose();
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
    await SchedulerBinding.instance.endOfFrame;
    if (!context.mounted) return;

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

    customCrossFadePush(context, ChatScreen(conversation: response.data!));
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

  Future<void> _sharePet(PetDetail pet) async {
    final url = pet.shareUrl;
    if (url == null || url.isEmpty) {
      if (mounted) {
        TO.show(context, 'Chưa có link chia sẻ');
      }
      return;
    }
    try {
      await Share.share(url);
    } catch (e) {
      debugPrint('[PetProfile] share error: $e');
      if (mounted) {
        TO.show(context, 'Chia sẻ không thành công');
      }
    }
  }

  void _showQr(PetDetail pet) {
    final url = pet.shareUrl;
    if (url == null || url.isEmpty) {
      TO.show(context, 'Chưa có link chia sẻ');
      return;
    }
    showQrShareSheet(context, data: url, title: 'QR chia sẻ hồ sơ');
  }

  String _buildAgeText(PetDetail pet) {
    final raw = pet.ageString;
    if (raw != null && raw.isNotEmpty) {
      final parts = raw.split('-');
      final years = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
      final months = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      final segments = <String>[];
      if (years > 0) segments.add('$years tuổi');
      if (months > 0) segments.add('$months tháng');
      if (segments.isNotEmpty) return segments.join(' ');
    }
    if (pet.age != null) return '${pet.age} tuổi';
    return '';
  }

  Future<void> _showLifeStageSheet(PetDetail pet) async {
    final stage = pet.lifeStage;
    final startMonth = stage?.startMonth;
    final endMonth = stage?.endMonth;
    final greenInfoText = () {
      if (startMonth != null && endMonth != null) {
        return '$startMonth-$endMonth tháng tuổi';
      }
      final ageText = _buildAgeText(pet);
      return ageText.isEmpty ? '--' : ageText;
    }();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AC.white,
      builder: (ctx) {
        return LifeStageSheet(
          stageLabel: stage?.label ?? '--',
          greenInfoText: greenInfoText,
          shortDescription: stage?.detail?.short?.trim() ?? '',
          bullets: stage?.detail?.bullets ?? const <String>[],
          careTips: stage?.detail?.careTips ?? const <String>[],
          healthWatch: stage?.detail?.healthWatch ?? const <String>[],
          onClose: () => Navigator.of(ctx).pop(),
        );
      },
    );
  }

  Future<void> _showBirthdaySheet(PetDetail pet) async {
    DateTime? selectedBirthday = pet.birthday != null
        ? DateTime.tryParse(pet.birthday!)
        : null;
    DateTime? selectedAdopted = pet.adoptedDate != null
        ? DateTime.tryParse(pet.adoptedDate!)
        : null;

    final updatedPet = await showModalBottomSheet<PetDetail?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AC.white,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              // padding: EdgeInsets.only(bottom: MQ.bottomPadding(context)),
              padding: EdgeInsets.zero,
              child: BirthDateEditorSheet(
                birthday: selectedBirthday,
                ageText: _buildAgeText(pet),
                adoptedDate: selectedAdopted,
                birthHint: 'Chọn ngày sinh',
                adoptedHint: 'Chọn ngày nhận nuôi',
                onBirthChanged: (d) => setState(() {
                  selectedBirthday = d;
                }),
                onAdoptedChanged: (d) => setState(() {
                  selectedAdopted = d;
                }),
                onConfirm: () async {
                  if (selectedBirthday == null) {
                    ToastOverlay.show(context, 'Vui lòng chọn ngày sinh');
                    return;
                  }

                  final resp = await PetService.updatePetByFields(
                    id: pet.id,
                    fields: {
                      'birthday': DateFormatConfig.dateOnlyToIsoLocal(
                        selectedBirthday!,
                      ),
                      'adopted_at': selectedAdopted != null
                          ? DateFormatConfig.dateOnlyToIsoLocal(
                              selectedAdopted!,
                            )
                          : null,
                    },
                  );
                  debugPrint('[PetProfile] updatePet resp: ${resp.data}');
                  if (!mounted) return;

                  if (resp.isSuccess) {
                    try {
                      final newPet = PetDetail.fromJson(
                        resp.data as Map<String, dynamic>,
                      );
                      Navigator.of(ctx).pop(newPet);
                    } catch (_) {
                      Navigator.of(ctx).pop(pet);
                    }
                  } else {
                    // ScaffoldMessenger.of(ctx).showSnackBar(
                    //   SnackBar(
                    //     content: Text(resp.message ?? 'Cập nhật thất bại'),
                    //   ),
                    // );
                    TO.show(context, resp.message ?? 'Cập nhật thất bại');
                  }
                },
              ),
            );
          },
        );
      },
    );

    if (updatedPet != null && mounted) {
      setState(() {
        _cachedData = _PetProfileData(
          pet: updatedPet,
          images: _cachedData?.images ?? [],
        );
      });
      TO.show(context, 'Đã cập nhật ngày sinh/nhận nuôi');
    }
  }

  Future<void> _showIdentityEditorScreen(PetDetail pet) async {
    PetGender selectedGender = pet.gender;
    bool isNeutered = pet.isNeutered;
    String breed = pet.breed;
    String hairColor = pet.hairColor ?? '';
    String weightText = pet.weight?.toString() ?? '';
    String appearance = pet.appearanceDetail ?? '';

    final updatedPet = await Navigator.of(context).push<PetDetail?>(
      MaterialPageRoute(
        builder: (screenCtx) {
          return IdentityEditorScreen(
            initialGender: selectedGender,
            initialIsNeutered: isNeutered,
            initialBreed: breed,
            initialHairColor: hairColor,
            initialWeight: weightText,
            initialAppearance: appearance,
            speciesCode: pet.speciesCode,
            onGenderChanged: (g) => selectedGender = g,
            onNeuteredChanged: (v) => isNeutered = v,
            onBreedChanged: (v) => breed = v,
            onHairColorChanged: (v) => hairColor = v,
            onWeightChanged: (v) => weightText = v,
            onAppearanceChanged: (v) => appearance = v,
            onConfirm: () async {
              final resp = await PetService.updatePetByFields(
                id: pet.id,
                fields: {
                  'gender': selectedGender.value,
                  'is_sterilized': isNeutered,
                  'breed': breed,
                  'color': hairColor,
                  'weight': double.tryParse(weightText),
                  'description': appearance,
                },
              );
              debugPrint('[PetProfile] update identity resp: ${resp.data}');

              if (!mounted) return;

              if (resp.isSuccess) {
                try {
                  final newPet = PetDetail.fromJson(
                    resp.data as Map<String, dynamic>,
                  );
                  Navigator.of(screenCtx).pop(newPet);
                } catch (_) {
                  Navigator.of(screenCtx).pop(pet);
                }
              } else {
                TO.show(screenCtx, 'Cập nhật thất bại');
              }
            },
          );
        },
      ),
    );

    if (updatedPet != null && mounted) {
      setState(() {
        _cachedData = _PetProfileData(
          pet: updatedPet,
          images: _cachedData?.images ?? [],
        );
      });
      TO.show(context, 'Đã cập nhật đặc điểm nhận dạng');
    }
  }

  void _onTapEditPersona(BuildContext context, PetDetail pet) {}

  Future<void> _showBriefEditorScreen(PetDetail pet) async {
    final brief = pet.brief;
    String traitsText = (brief?.traits != null && brief!.traits!.isNotEmpty)
        ? brief.traits!.join(', ')
        : '';
    String likesText = (brief?.likes != null && brief!.likes!.isNotEmpty)
        ? brief.likes!.join(', ')
        : '';
    String dislikesText =
        (brief?.dislikes != null && brief!.dislikes!.isNotEmpty)
        ? brief.dislikes!.join(', ')
        : '';
    String dietText = (brief?.diet != null && brief!.diet!.isNotEmpty)
        ? brief.diet!.join(', ')
        : '';

    final updatedPet = await Navigator.of(context).push<PetDetail?>(
      MaterialPageRoute(
        builder: (ctx) => BriefEditorScreen(
          initialTraits: traitsText,
          initialLikes: likesText,
          initialDislikes: dislikesText,
          initialDiet: dietText,
          onTraitsChanged: (v) => traitsText = v,
          onLikesChanged: (v) => likesText = v,
          onDislikesChanged: (v) => dislikesText = v,
          onDietChanged: (v) => dietText = v,
          onConfirm: () async {
            final traitsList = traitsText
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            final likesList = likesText
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            final dislikesList = dislikesText
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            final dietList = dietText
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();

            final resp = await PetService.updatePetBriefNotes(
              id: pet.id,
              traits: traitsList,
              likes: likesList,
              dislikes: dislikesList,
              diet: dietList,
            );
            debugPrint('[PetProfile] update brief resp: ${resp.data}');

            if (resp.isSuccess) {
              try {
                final newPet = PetDetail.fromJson(
                  resp.data as Map<String, dynamic>,
                );
                Navigator.of(ctx).pop(newPet);
              } catch (_) {
                Navigator.of(ctx).pop(pet);
              }
            } else {
              TO.show(ctx, 'Cập nhật thất bại');
            }
          },
        ),
      ),
    );

    if (updatedPet != null && mounted) {
      setState(() {
        _cachedData = _PetProfileData(
          pet: updatedPet,
          images: _cachedData?.images ?? [],
        );
      });
      TO.show(context, 'Đã cập nhật tính cách & sở thích');
    }
  }

  Future<void> _showNameAvatarEditorScreen(PetDetail pet) async {
    final updatedPet = await Navigator.push<PetDetail?>(
      context,
      MaterialPageRoute(
        builder: (_) => NameAvatarEditorScreen(
          initialName: pet.name,
          initialAvatarUrl: pet.avatarUrl,
          onConfirm: (name, avatarUrl) async {
            final resp = await PetService.updatePetByFields(
              id: pet.id,
              fields: {
                'name': name,
                if (avatarUrl != null) 'avatar': avatarUrl,
              },
            );
            debugPrint('[PetProfile] update name/avatar resp: ${resp.data}');
            if (!mounted) return;
            if (resp.isSuccess) {
              try {
                final newPet = PetDetail.fromJson(
                  resp.data as Map<String, dynamic>,
                );
                Navigator.of(context).pop(newPet);
              } catch (_) {
                Navigator.of(context).pop(pet);
              }
            } else {
              TO.show(context, resp.message ?? 'Cập nhật thất bại');
            }
          },
        ),
      ),
    );

    if (updatedPet != null && mounted) {
      setState(() {
        _cachedData = _PetProfileData(
          pet: updatedPet,
          images: _cachedData?.images ?? [],
        );
      });
      TO.show(context, 'Đã cập nhật tên/ảnh đại diện');
    }
  }

  Future<void> _showOtherDataEditorScreen(PetDetail pet) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (ctx) =>
            OtherDataEditorScreen(petId: pet.id, onExtrasChanged: (_) {}),
      ),
    );

    if (!mounted) return;
    final refreshed = await _loadPetData(_cachedData?.pet);
    if (!mounted || refreshed == null) return;
    setState(() => _cachedData = refreshed);
  }

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
    final topSafe = MediaQuery.of(context).padding.top;

    final data = _cachedData;
    if (_isLoading || data == null) {
      final child = _isLoading
          ? const TextLoadingIndicator(text: 'Đang tải dữ liệu của bé...')
          : Text(AppLocalizations.of(context)!.petProfileNotFound);
      return CustomScaffold(body: Center(child: child));
    }

    final pet = data.pet;
    final images = data.images;
    final screenHeight = MediaQuery.of(context).size.height;
    final minChildSize =
        1 - (SC.sh(112) + topSafe) / screenHeight; // top at 112
    final maxChildSize = (screenHeight - SC.sh(16)) / screenHeight;

    if (_sheetExtent.value == 0) {
      _sheetExtent.value = minChildSize;
    }

    return _PetProfileContent(
      pet: pet,
      ageText: _buildAgeText(pet),
      imageUrls: images,
      onTapEditPet: () => _onTapEditPet(context, pet),
      onTapChat: () => _onTapChat(context, pet),
      onTapEditPersona: () => _onTapEditPersona(context, pet),
      onTapEditNameAvatar: () => _showNameAvatarEditorScreen(pet),
      onTapShare: () => _sharePet(pet),
      onTapQr: () => _showQr(pet),
      onTapShield: () => {},
      onTapEditBirthday: () => _showBirthdaySheet(pet),
      onTapLifeStage: () => _showLifeStageSheet(pet),
      onTapEditIdentity: () => _showIdentityEditorScreen(pet),
      onTapEditTraits: () => _showBriefEditorScreen(pet),
      onTapEditOtherData: () => _showOtherDataEditorScreen(pet),
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      sheetExtentNotifier: _sheetExtent,
    );
  }
}

class _PetProfileData {
  final PetDetail pet;
  final List<String> images;
  _PetProfileData({required this.pet, required this.images});
}

// ---------------------------------------------------------------------------
//  PHẦN NỘI DUNG CHÍNH
// ---------------------------------------------------------------------------

class _PetProfileContent extends StatelessWidget {
  final PetDetail pet;
  final String ageText;
  final List<String> imageUrls;
  final VoidCallback onTapShare;
  final VoidCallback onTapQr;
  final VoidCallback onTapEditPet;
  final VoidCallback onTapChat;
  final VoidCallback onTapEditPersona;
  final VoidCallback onTapEditNameAvatar;
  final VoidCallback onTapShield;
  final VoidCallback onTapEditBirthday;
  final VoidCallback onTapLifeStage;
  final VoidCallback onTapEditIdentity;
  final VoidCallback onTapEditTraits;
  final VoidCallback onTapEditOtherData;
  final double minChildSize;
  final double maxChildSize;
  final ValueNotifier<double> sheetExtentNotifier;
  const _PetProfileContent({
    required this.pet,
    required this.ageText,
    required this.imageUrls,
    required this.onTapEditPet,
    required this.onTapChat,
    required this.onTapEditPersona,
    required this.onTapEditNameAvatar,
    required this.onTapShare,
    required this.onTapQr,
    required this.onTapShield,
    required this.onTapEditBirthday,
    required this.onTapLifeStage,
    required this.onTapEditIdentity,
    required this.onTapEditTraits,
    required this.onTapEditOtherData,
    required this.minChildSize,
    required this.maxChildSize,
    required this.sheetExtentNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/pet-profile-cover-image.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            // White background section (draggable)
            Positioned.fill(
              child: Builder(
                builder: (context) {
                  return NotificationListener<DraggableScrollableNotification>(
                    onNotification: (notification) {
                      sheetExtentNotifier.value = notification.extent;
                      return false;
                    },
                    child: DraggableScrollableSheet(
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
                                  SC.sw(16),
                                  0,
                                  SC.sw(16),
                                  0,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: SC.sh(8)),
                                    _HeaderSection(
                                      pet: pet,
                                      onTapEditNameAvatar: onTapEditNameAvatar,
                                    ),
                                    SizedBox(height: SC.sh(24)),
                                    _LifeStageCard(
                                      pet: pet,
                                      ageText: ageText,
                                      onTapDetails: onTapLifeStage,
                                    ),
                                    SizedBox(height: SC.sh(16)),
                                    _PicturesSection(imageUrls: imageUrls),
                                    SizedBox(height: SC.sh(24)),
                                    _ImportantHealthSection(
                                      pet: pet,
                                      onTapBirthday: onTapEditBirthday,
                                    ),
                                    SizedBox(height: SC.sh(16)),
                                    _TraitsSection(
                                      pet: pet,
                                      onTapEditTraits: onTapEditTraits,
                                    ),
                                    SizedBox(height: SC.sh(16)),
                                    _IdentitySection(
                                      pet: pet,
                                      onTapIdentity: onTapEditIdentity,
                                    ),
                                    SizedBox(height: SC.sh(16)),
                                    _OtherDataSection(
                                      pet: pet,
                                      onTapEditOtherData: onTapEditOtherData,
                                    ),
                                    SizedBox(height: SC.sh(16)),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: -SC.sh(24),
                              child: _AvatarWithWhisper(pet: pet),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder<double>(
                valueListenable: sheetExtentNotifier,
                builder: (context, extent, _) {
                  final current = extent == 0 ? minChildSize : extent;
                  final denom = (maxChildSize - minChildSize) * 0.75;
                  final t = denom <= 0
                      ? 1.0
                      : ((current - minChildSize) / denom).clamp(0.0, 1.0);
                  final bgColor = AC.white.withOpacity(t);
                  return _ScreenHeader(
                    title: pet.name,
                    titleOpacity: t,
                    onTapShare: onTapShare,
                    onTapQr: onTapQr,
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
  final String? title;
  final double? titleOpacity;
  final VoidCallback onTapShare;
  final VoidCallback onTapQr;
  final VoidCallback onTapChat;
  // final VoidCallback onTapEdit;
  // final VoidCallback onTapShield;

  const _ScreenHeader({
    this.title,
    this.titleOpacity,
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
              child: SizedBox(
                height: SC.sh(20),
                width: SC.sh(20),
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      opacity: 1 - (titleOpacity ?? 0),
                      duration: const Duration(milliseconds: 120),
                      child: Image.asset(
                        'assets/icons/left-arrow-white.png',
                        height: SC.sh(20),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: titleOpacity ?? 0,
                      duration: const Duration(milliseconds: 120),
                      child: Image.asset(
                        'assets/icons/left-arrow-black.png',
                        height: SC.sh(20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (title != null)
              Expanded(
                child: AnimatedOpacity(
                  opacity: titleOpacity ?? 1.0,
                  duration: const Duration(milliseconds: 120),
                  child: Padding(
                    padding: EdgeInsets.only(left: SC.sw(16)),
                    child: Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        fontSize: SC.sf(16),
                        color: AC.blackText6,
                      ),
                    ),
                  ),
                ),
              )
            else
              const Spacer(),
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
//  QUICK CHAT / NOTE CARDS
// ---------------------------------------------------------------------------

class _LifeStageCard extends StatelessWidget {
  final PetDetail pet;
  final String ageText;
  final VoidCallback onTapDetails;
  const _LifeStageCard({
    required this.pet,
    required this.ageText,
    required this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    final lifeStageLabel = pet.lifeStage?.label ?? '--';
    final humanAgeText = pet.humanAge != null
        ? '~${pet.humanAge} tuổi người'
        : '';
    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: SC.sh(116),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/life-stage-background.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
              // boxShadow: const [
              //   BoxShadow(
              //     color: Color.fromRGBO(0, 0, 0, 0.06),
              //     blurRadius: 12,
              //     offset: Offset(0, 6),
              //   ),
              // ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: SC.sw(24),
                  top: SC.sh(16),
                  bottom: 0,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/images/life-stage-art-cat-3.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    SC.sw(16),
                    SC.sh(16),
                    SC.sw(16),
                    SC.sh(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Giai đoạn',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w500,
                              fontSize: SC.sf(14),
                              color: AC.blackText6,
                            ),
                          ),
                          SizedBox(width: SC.sw(8)),
                          TapEffect(
                            onTap: onTapDetails,
                            child: Container(
                              width: SC.smin(24),
                              height: SC.smin(24),
                              padding: EdgeInsets.all(SC.smin(4)),
                              decoration: BoxDecoration(
                                color: AC.greyTab1,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/icons/open-details-green.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SC.sh(4)),
                      Text(
                        lifeStageLabel,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: SC.sf(24),
                          color: AC.blackText6,
                        ),
                      ),
                      SizedBox(height: SC.sh(4)),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: ageText,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                                fontSize: SC.sf(12),
                                color: AC.greenStrong1,
                              ),
                            ),
                            if (humanAgeText.isNotEmpty) ...[
                              TextSpan(
                                text: ' Tương đương ',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w400,
                                  fontSize: SC.sf(12),
                                  color: AC.greyText4,
                                ),
                              ),
                              TextSpan(
                                text: humanAgeText,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                  fontSize: SC.sf(12),
                                  color: AC.greenStrong1,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Image.asset(
          //     'assets/images/pet-profile-life-stage.png',
          //     height: SC.sh(128),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _PicturesSection extends StatelessWidget {
  final List<String> imageUrls;
  const _PicturesSection({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    final urls = imageUrls;
    final displayUrls = List<String>.generate(
      4,
      (index) => index < urls.length ? urls[index] : '',
    );
    final showSeeAll = urls.length > 4;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: SC.sw(8)),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(12),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.05),
      //       blurRadius: 8,
      //       offset: const Offset(0, 4),
      //     ),
      //   ],
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hình ảnh',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(16),
                  color: AC.blackTitleStrong,
                ),
              ),
              const Spacer(),
              if (showSeeAll)
                TapEffect(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AllPicturesScreen(imageUrls: urls),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SC.sw(8),
                      vertical: SC.sh(4),
                    ),
                    decoration: BoxDecoration(
                      color: AC.greenStrong1.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Xem tất cả (${urls.length})',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                            fontSize: SC.sf(12),
                            color: AC.greenStrong1,
                          ),
                        ),
                        SizedBox(width: SC.sw(4)),
                        Icon(
                          Icons.chevron_right,
                          size: SC.smin(16),
                          color: AC.greenStrong1,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: SC.sh(8)),
          if (urls.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: SC.sw(16),
                vertical: SC.sh(16),
              ),
              decoration: BoxDecoration(
                color: AC.greyTab1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: SC.smin(24),
                    color: AC.neutralInfoHint,
                  ),
                  SizedBox(width: SC.sw(8)),
                  Text(
                    'Chưa có ảnh',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      fontSize: SC.sf(13),
                      color: AC.greyText4,
                    ),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final spacing = SC.sw(8);
                final itemSize =
                    (constraints.maxWidth - spacing * 3) / 4; // 4 items one row
                return Row(
                  children: List.generate(displayUrls.length, (index) {
                    final url = displayUrls[index];
                    final thumb = url.isEmpty
                        ? SizedBox(width: itemSize, height: itemSize)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: RectangleCachedNetworkImage(
                              imageUrl: url,
                              width: itemSize,
                              height: itemSize,
                              fit: BoxFit.cover,
                            ),
                          );
                    return Padding(
                      padding: EdgeInsets.only(right: index == 3 ? 0 : spacing),
                      child: thumb,
                    );
                  }),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  IMPORTANT EVENTS & HEALTH
// ---------------------------------------------------------------------------

class _ImportantHealthSection extends StatelessWidget {
  final PetDetail pet;
  final VoidCallback? onTapBirthday;
  const _ImportantHealthSection({required this.pet, this.onTapBirthday});

  @override
  Widget build(BuildContext context) {
    final birthdayText = pet.birthday != null && pet.birthday!.isNotEmpty
        ? 'Ngày ${DateFormatConfig.isoToLongDisplay(pet.birthday!)}'
        : '--';
    return _InfoListSection(
      title: 'Sự kiện quan trọng & sức khoẻ',
      items: [
        _InfoItem(
          icon: Image.asset(
            'assets/icons/pet-profile-info-item-birthday.png',
            height: SC.smin(24),
          ),
          iconBg: AC.greyTab1,
          label: 'Sinh nhật',
          value: birthdayText,
          badgeText: null,
          onTap: onTapBirthday,
        ),
        // _InfoItem(
        //   icon: Icons.vaccines_outlined,
        //   iconBg: AC.greyTab1,
        //   label: 'Hẹn tiêm vắc-xin',
        //   value: 'Ngày tiêm',
        //   helper: 'Còn 1 mũi nhắc lại',
        //   badgeText: 'Cần lưu ý',
        //   badgeColor: AC.redValidationText,
        // ),
        // _InfoItem(
        //   icon: Icons.pets_outlined,
        //   iconBg: AC.greyTab1,
        //   label: 'Hẹn xổ giun định kỳ',
        //   value: 'Ngày xổ giun',
        //   // helper: 'Nhắc lại sau 3 tháng',
        //   badgeText: null,
        // ),
      ],
    );
  }
}

class _TraitsSection extends StatelessWidget {
  final PetDetail pet;
  final VoidCallback? onTapEditTraits;
  const _TraitsSection({required this.pet, this.onTapEditTraits});

  @override
  Widget build(BuildContext context) {
    final brief = pet.brief;
    final traitsText = (brief?.traits != null && brief!.traits!.isNotEmpty)
        ? brief.traits!.join(', ')
        : '--';
    final likes = brief?.likes ?? [];
    final dislikes = brief?.dislikes ?? [];
    final likesText = likes.isNotEmpty ? likes.join(', ') : '--';
    final dislikesText = dislikes.isNotEmpty ? dislikes.join(', ') : '--';
    final loveHateText = 'Yêu: $likesText\nGhét: $dislikesText';
    final dietText = (brief?.diet != null && brief!.diet!.isNotEmpty)
        ? brief.diet!.join(', ')
        : '--';

    return _InfoListSection(
      title: 'Tính cách & sở thích',
      items: [
        _InfoItem(
          icon: Image.asset(
            'assets/icons/pet-profile-info-item-traits.png',
            height: SC.smin(24),
          ),
          iconBg: AC.greyTab1,
          label: 'Tính cách',
          value: traitsText,
          badgeText: null,
          onTap: onTapEditTraits,
        ),
        _InfoItem(
          icon: Image.asset(
            'assets/icons/pet-profile-info-item-likes.png',
            height: SC.smin(24),
          ),
          iconBg: AC.greyTab1,
          label: 'Yêu & ghét',
          value: loveHateText,
          badgeText: null,
          onTap: onTapEditTraits,
        ),
        _InfoItem(
          icon: Image.asset(
            'assets/icons/pet-profile-info-item-food.png',
            height: SC.smin(24),
          ),
          iconBg: AC.greyTab1,
          label: 'Thức ăn',
          value: dietText,
          badgeText: null,
          onTap: onTapEditTraits,
        ),
      ],
    );
  }
}

class _IdentitySection extends StatelessWidget {
  final PetDetail pet;
  final VoidCallback? onTapIdentity;
  const _IdentitySection({required this.pet, required this.onTapIdentity});

  @override
  Widget build(BuildContext context) {
    final genderText = pet.gender.label;
    final neuterText = pet.isNeutered ? 'đã triệt sản' : 'chưa triệt sản';
    final genderValue = '$genderText - $neuterText';
    final sizeLabel = () {
      final raw = pet.size;
      if (raw == null || raw.isEmpty) return '--';
      final upper = raw.toUpperCase();
      if (upper == 'S' || upper == 'XS') return 'Nhỏ ($raw)';
      if (upper == 'M') return 'Vừa (M)';
      return 'Lớn ($raw)';
    }();
    return _InfoListSection(
      title: 'Đặc điểm nhận dạng',
      items: [
        _InfoItem(
          icon: Image.asset(
            'assets/icons/pet-profile-info-item-gender.png',
            height: SC.smin(24),
          ),
          iconBg: AC.greyTab1,
          label: 'Giới tính & sinh sản',
          value: genderValue,
          badgeText: null,
          onTap: onTapIdentity,
        ),
        _InfoItem(
          icon: Image.asset(
            'assets/icons/pet-profile-info-item-height.png',
            height: SC.smin(24),
          ),
          iconBg: AC.greyTab1,
          label: 'Cân nặng',
          value: '${pet.weight ?? '--'} kg - $sizeLabel',
          badgeText: null,
          onTap: onTapIdentity,
        ),
        _InfoItem(
          icon: Image.asset(
            'assets/icons/pet-profile-info-item-breed.png',
            height: SC.smin(24),
          ),
          iconBg: AC.greyTab1,
          label: 'Giống loài & màu sắc',
          value: '${pet.breed} - ${pet.hairColor ?? '--'}',
          badgeText: null,
          onTap: onTapIdentity,
        ),
        _InfoItem(
          icon: Image.asset(
            'assets/icons/pet-profile-info-item-appearance.png',
            height: SC.smin(24),
          ),
          iconBg: AC.greyTab1,
          label: 'Ngoại hình và dấu hiệu đặc trưng',
          value: pet.appearanceDetail ?? '--',
          badgeText: null,
          onTap: onTapIdentity,
        ),
      ],
    );
  }
}

class _OtherDataSection extends StatelessWidget {
  final PetDetail pet;
  final VoidCallback? onTapEditOtherData;
  const _OtherDataSection({required this.pet, this.onTapEditOtherData});

  @override
  Widget build(BuildContext context) {
    final extras = (pet.brief?.extras ?? [])
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final previewExtras = extras.length <= 2 ? extras : extras.sublist(0, 2);
    final previewLines = <String>[...previewExtras];
    if (extras.length > 2) {
      previewLines.add('...');
    }
    final extrasText = extras.isEmpty
        ? 'Chưa có lưu ý'
        : previewLines.join('\n');
    final extrasTextColor = extras.isEmpty ? AC.greyText5 : null;
    return _InfoListSection(
      title: 'Dữ liệu khác',
      items: [
        _InfoItem(
          icon: Image.asset(
            'assets/icons/pet-profile-info-item-other.png',
            height: SC.smin(24),
          ),
          iconBg: AC.greyTab1,
          label: 'Lưu ý khác',
          value: extrasText,
          valueColor: extrasTextColor,
          badgeText: null,
          onTap: onTapEditOtherData,
        ),
      ],
    );
  }
}

class _InfoListSection extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;
  const _InfoListSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // padding: EdgeInsets.only(bottom: SC.sh(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(SC.sw(8), SC.sh(8), SC.sw(8), 0),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    fontSize: SC.sf(16),
                    color: AC.blackTitleStrong,
                  ),
                ),
              ],
            ),
          ),
          ...items.map((e) => e),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final Widget icon;
  final Color iconBg;
  final String label;
  final String value;
  final Color? valueColor;
  final String? helper;
  final String? badgeText;
  final Color? badgeColor;
  final VoidCallback? onTap;

  const _InfoItem({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.value,
    this.valueColor,
    this.helper,
    this.badgeText,
    this.badgeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.fromLTRB(SC.sw(8), SC.sh(16), SC.sw(8), SC.sh(8)),
      // padding: EdgeInsets.fromLTRB(0, SC.sh(16), 0, SC.sh(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SC.smin(46),
            height: SC.smin(46),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(padding: EdgeInsets.all(SC.smin(12)), child: icon),
          ),
          SizedBox(width: SC.sw(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: SC.sf(12),
                          color: AC.greyText2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (badgeText != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SC.sw(8),
                          vertical: SC.sh(2),
                        ),
                        decoration: BoxDecoration(
                          color: (badgeColor ?? AC.redValidationText)
                              .withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badgeText!,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                            fontSize: SC.sf(10),
                            color: badgeColor ?? AC.redValidationText,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: SC.sh(4)),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    fontSize: SC.sf(14),
                    color: valueColor ?? AC.slateHeadingDark,
                  ),
                ),
                if (helper != null) ...[
                  SizedBox(height: SC.sh(4)),
                  Text(
                    helper!,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(10),
                      color: AC.slateSecondaryText,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: SC.sw(8)),
          TapEffect(
            onTap: onTap,
            child: Container(
              width: SC.smin(24),
              height: SC.smin(48),
              decoration: BoxDecoration(
                color: AC.greyTab1,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/icons/pet-profile-see-more.png',
                height: SC.smin(16),
                width: SC.smin(16),
              ),
            ),
          ),
        ],
      ),
    );

    return content;
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
      padding: EdgeInsets.only(left: SC.sw(16)),
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
  final VoidCallback onTapEditNameAvatar;
  // final VoidCallback onTapChat;
  // const _HeaderSection({required this.pet, required this.onTapChat});
  const _HeaderSection({required this.pet, required this.onTapEditNameAvatar});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: SC.sw(88)),
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
                    onTap: onTapEditNameAvatar,
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
            value: pet.weight != null ? '${pet.weight} kg' : '--',
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
            width: SC.smin(24),
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
            width: SC.smin(24),
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
              : '--',
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
