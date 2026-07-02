import 'package:flutter/material.dart';
import 'package:capcat_doca/models/pet_species_master_data.dart';
import 'package:capcat_doca/screens/main/chat/chat_screen_new.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/pet_form_landing_screen.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_profile/pet_profile_screen.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/edit_pet_persona_screen.dart';
import 'package:capcat_doca/services/chat_conversation_remote_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/navigation_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';
import 'package:capcat_doca/widgets/loading/text_loading_indicator.dart';

class Backup260305MyPetsScreen extends ConsumerStatefulWidget {
  const Backup260305MyPetsScreen({super.key});

  static final _hp = SC.sw(24);
  static final _vp = SC.sh(24);

  @override
  ConsumerState<Backup260305MyPetsScreen> createState() =>
      _Backup260305MyPetsScreenState();
}

class _Backup260305MyPetsScreenState
    extends ConsumerState<Backup260305MyPetsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _shouldAnimate = false;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..value = 1;

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween(begin: const Offset(0, 0.07), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _shouldAnimate = true;
    });
    await ref.read(listPetDetailProvider.notifier).refresh();
  }

  void _refreshPets() {
    ref.read(listPetDetailProvider.notifier).refresh();
  }

  Future<void> _onTapAddPet(BuildContext context) async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PetFormLandingScreen()),
    );
    if (created is PetDetail && mounted) {
      await ref.read(listPetDetailProvider.notifier).upsertPet(created);
    } else if (created == true && mounted) {
      _refreshPets();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petsAsync = ref.watch(listPetDetailProvider);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        CustomAppHeader(
          title: l10n.myPetsTitle,
          hasLeftAction: false,
          color: AC.white,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsetsGeometry.only(bottom: MQ.bottomPadding(context)),
            child: petsAsync.when(
              loading: () => Center(
                child: TextLoadingIndicator(
                  text: 'Đang tải danh sách thú cưng...',
                ),
              ),
              error: (error, _) {
                _shouldAnimate = false;
                return _ErrorState(
                  message: l10n.myPetsLoadError,
                  onRetry: () =>
                      ref.read(listPetDetailProvider.notifier).refresh(),
                  l10n: l10n,
                );
              },
              data: (pets) {
                if (pets.isEmpty) {
                  _shouldAnimate = false;
                  _animController.value = 1;
                } else if (_shouldAnimate) {
                  _animController.forward(from: 0);
                  _shouldAnimate = false;
                }

                return RefreshIndicator(
                  color: AC.greenStrong1,
                  backgroundColor: AC.white,
                  onRefresh: _onRefresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      Backup260305MyPetsScreen._hp,
                      0,
                      Backup260305MyPetsScreen._hp,
                      Backup260305MyPetsScreen._vp,
                    ),
                    children: [
                      SizedBox(height: SC.sh(16)),
                      Center(
                        child: _AddNewPetButton(
                          onTap: () => _onTapAddPet(context),
                          label: l10n.myPetsAddNew,
                        ),
                      ),
                      SizedBox(height: SC.sh(16)),
                      if (pets.isEmpty) ...[
                        const _EmptyState(),
                        SizedBox(
                          height: SC.sh(SC.desBotBarHeight + SC.desBotBarVp),
                        ),
                      ] else ...[
                        Container(
                          width: double.infinity,
                          height: SC.sh(1),
                          color: AC.greyLine2,
                        ),
                        // SizedBox(height: SC.sh(12)),
                        FadeTransition(
                          opacity: _fadeAnim,
                          child: SlideTransition(
                            position: _slideAnim,
                            child: Column(
                              children: [
                                ...pets.map(
                                  (pet) => _PetCard(
                                    pet: pet,
                                    onPetUpdated: (updated) async {
                                      await ref
                                          .read(listPetDetailProvider.notifier)
                                          .upsertPet(updated);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SC.sh(SC.desBotBarHeight + SC.desBotBarVp),
                          // + MediaQuery.of(context).padding.bottom,
                        ),
                      ],
                    ],
                  ),
                  //         ],
                  // ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

//==============================================================
//  PET CARD — Same as before
//==============================================================

class _PetCard extends StatelessWidget {
  const _PetCard({required this.pet, required this.onPetUpdated});
  final PetDetail pet;
  final ValueChanged<PetDetail> onPetUpdated;

  static final double _cardHeight = SC.sh(104);
  static final double _avatarSize = SC.smin(56);
  static final double _radius = 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Column(
        children: [
          const Spacer(),
          Row(
            children: [
              SizedBox(width: SC.sw(8)),
              Expanded(
                child: TapEffect(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PetProfileScreen(petId: pet.id),
                      ),
                    );
                    if (result is PetDetail) {
                      onPetUpdated(result);
                    }
                  },
                  child: Row(
                    children: [
                      CircleCachedNetworkImage(
                        imageUrl: pet.avatarUrl!,
                        size: _avatarSize,
                        subject: ImageSubject.pet,
                      ),
                      SizedBox(width: SC.sw(10)),
                      Expanded(child: _PetTexts(pet: pet)),
                    ],
                  ),
                ),
              ),
              TapEffect(
                onTap: () => _handleChatTap(context),
                child: Image.asset(
                  'assets/icons/my-pets-chat.png',
                  width: SC.smin(40),
                  height: SC.smin(40),
                ),
              ),
              SizedBox(width: SC.sw(8)),
            ],
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            height: SC.sh(1),
            color: AC.greyLine2,
          ),
        ],
      ),
    );
  }

  Future<void> _handleChatTap(BuildContext context) async {
    final response = await ChatConversationRemoteService.startConversation(
      petId: pet.id,
    );
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;

    if (!response.isSuccess || response.data == null) {
      if (response.errorCode == 'AI_AGENT_INFO_NOT_FOUND') {
        customCrossFadePush(context, EditPetPersonaScreen(petId: pet.id));
        return;
      }
      final message = response.message ?? l10n.myPetsStartChatError;
      TO.show(context, message);
      return;
    }

    customCrossFadePush(context, ChatScreenNew(conversation: response.data!));
  }
}

class _PetTexts extends StatelessWidget {
  const _PetTexts({required this.pet});
  final PetDetail pet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              pet.name,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: SC.sf(16),
                color: AC.blackText5,
              ),
            ),
            SizedBox(width: SC.sw(4)),
            Image.asset(
              pet.gender == PetGender.male
                  ? 'assets/icons/male-simple.png'
                  : 'assets/icons/female-simple.png',
              width: SC.smin(16),
            ),
          ],
        ),
        SizedBox(height: SC.sh(2)),
        Row(
          children: [
            Text(
              PetSpeciesMasterData.fromCodeToName(pet.speciesCode),
              style: TextStyle(
                // fontFamily: 'Noto Sans',
                fontSize: SC.sf(14),
                color: AC.greyText5,
              ),
            ),
            SizedBox(width: SC.sw(6)),
            Text(
              '|',
              style: TextStyle(color: AC.slateCardBorder, fontSize: SC.sf(14)),
            ),
            SizedBox(width: SC.sw(6)),
            Flexible(
              child: Text(
                pet.breed,
                style: TextStyle(
                  // fontFamily: 'Noto Sans',
                  fontSize: SC.sf(14),
                  color: AC.greyText5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(24),
          vertical: SC.sh(24),
        ),
        child: Text(
          l10n.myPetsEmpty,
          style: TextStyle(
            // fontFamily: 'Noto Sans',
            fontSize: SC.sf(16),
            color: AC.greyText5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.l10n,
  });

  final String message;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SC.sw(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                // fontFamily: 'Noto Sans',
                fontSize: SC.sf(16),
                color: AC.greyText5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SC.sh(12)),
            TapEffect(
              onTap: onRetry,
              child: Text(
                l10n.myPetsRetry,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: SC.sf(14),
                  color: AppColors.greenStrong1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddNewPetButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const _AddNewPetButton({required this.onTap, required this.label});
  @override
  Widget build(BuildContext context) {
    // return TapEffect(
    //   onTap: onTap,
    //   child: Padding(
    //     padding: EdgeInsets.symmetric(vertical: SC.sh(6)),
    //     child: Text(
    //       '+ Thêm mới',
    //       style: TextStyle(
    //         fontFamily: 'Quicksand',
    //         fontWeight: FontWeight.w700,
    //         fontSize: SC.sf(14),
    //         color: AC.greenStrong1,
    //       ),
    //     ),
    //   ),
    // );

    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Icon(
    //       Icons.add_circle_outline,
    //       size: SC.smin(18),
    //       color: AppColors.greenStrong1,
    //     ),
    //     SizedBox(width: SC.sw(4)),
    //     Text(
    //       'Thêm mới',
    //       style: TextStyle(
    //         fontWeight: FontWeight.w700,
    //         color: AppColors.greenStrong1,
    //       ),
    //     ),
    //   ],
    // );

    return TapEffect(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: SC.sh(56),
        padding: EdgeInsets.symmetric(vertical: SC.sh(16)),
        decoration: BoxDecoration(
          color: AC.greyBox1,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AC.greenCardSoftBg),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: SC.smin(16), color: AppColors.greenStrong1),
              SizedBox(width: SC.sw(8)),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(14),
                  color: AppColors.greenStrong1,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return ActionButton(
    //   leadingIcon: Icon(Icons.add, size: SC.smin(18), color: AC.greenStrong1),
    //   text: 'Thêm thú cưng mới',
    //   onTap: onTap,
    //   color: AC.greyBox1,
    //   borderColor: AC.greenCardSoftBg,
    //   textColor: AC.greenStrong1,
    // );
  }
}
