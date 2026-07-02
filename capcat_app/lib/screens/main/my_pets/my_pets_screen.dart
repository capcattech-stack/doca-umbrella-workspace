import 'package:flutter/material.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/pet_form_landing_screen.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart';
import 'package:capcat_doca/widgets/loading/text_loading_indicator.dart';
import 'package:capcat_doca/widgets/pet/add_pet_intro_card.dart';
import 'package:capcat_doca/widgets/pet/pet_profile_card.dart';

class MyPetsScreen extends ConsumerStatefulWidget {
  const MyPetsScreen({super.key});

  static final _hp = SC.sw(16);
  static final _vp = SC.sh(24);

  @override
  ConsumerState<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends ConsumerState<MyPetsScreen>
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
          title: 'Hồ sơ thú cưng',
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
                      MyPetsScreen._hp,
                      0,
                      MyPetsScreen._hp,
                      MyPetsScreen._vp,
                    ),
                    children: [
                      SizedBox(height: SC.sh(16)),
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: _PetMasonryLayout(
                            pets: pets,
                            onTapAddPet: () => _onTapAddPet(context),
                            emptyMessage: l10n.myPetsEmpty,
                            onPetUpdated: (updated) async {
                              await ref
                                  .read(listPetDetailProvider.notifier)
                                  .upsertPet(updated);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SC.sh(SC.desBotBarHeight + SC.desBotBarVp),
                      ),
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

class _PetMasonryLayout extends StatelessWidget {
  const _PetMasonryLayout({
    required this.pets,
    required this.onTapAddPet,
    required this.emptyMessage,
    required this.onPetUpdated,
  });

  final List<PetDetail> pets;
  final VoidCallback onTapAddPet;
  final String emptyMessage;
  final ValueChanged<PetDetail> onPetUpdated;

  @override
  Widget build(BuildContext context) {
    if (pets.isEmpty) {
      return Column(
        children: [
          AddPetIntroCard(onTap: onTapAddPet),
          SizedBox(height: SC.sh(12)),
          _EmptyState(message: emptyMessage),
        ],
      );
    }

    final leftPets = <PetDetail>[];
    final rightPets = <PetDetail>[];
    for (int i = 0; i < pets.length; i++) {
      if (i.isEven) {
        rightPets.add(pets[i]);
      } else {
        leftPets.add(pets[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              AddPetIntroCard(onTap: onTapAddPet),
              if (leftPets.isNotEmpty) SizedBox(height: SC.sh(12)),
              for (int i = 0; i < leftPets.length; i++) ...[
                PetProfileCard(pet: leftPets[i], onPetUpdated: onPetUpdated),
                if (i < leftPets.length - 1) SizedBox(height: SC.sh(12)),
              ],
            ],
          ),
        ),
        SizedBox(width: SC.sw(12)),
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < rightPets.length; i++) ...[
                PetProfileCard(pet: rightPets[i], onPetUpdated: onPetUpdated),
                if (i < rightPets.length - 1) SizedBox(height: SC.sh(12)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(24),
          vertical: SC.sh(24),
        ),
        child: Text(
          message ?? AppLocalizations.of(context)!.myPetsEmpty,
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
