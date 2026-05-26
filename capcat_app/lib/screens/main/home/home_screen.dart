import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/providers/list_pet_detail_provider.dart';
import 'package:flutter_chat_mock_app/providers/main_navigation_provider.dart';
import 'package:flutter_chat_mock_app/providers/moments_provider.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_form/pet_form_landing_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/moments/moment_form_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/moments/widgets/moments_list_view.dart';
import 'package:flutter_chat_mock_app/services/moment_remote_service.dart';
import 'package:flutter_chat_mock_app/storage/user_detail_local_storage.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/loading/text_loading_indicator.dart';
import 'package:flutter_chat_mock_app/widgets/pet/add_pet_intro_card.dart';
import 'package:flutter_chat_mock_app/widgets/pet/pet_profile_card.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _userAvatar;
  final ScrollController _nestedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
  }

  @override
  void dispose() {
    _nestedScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAvatar() async {
    final user = await UserDetailLocalStorage().read();
    if (!mounted) return;
    setState(() {
      _userAvatar = user?.avatarUrl;
    });
  }

  Future<void> _onTapAddPet() async {
    final created = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PetFormLandingScreen()));
    if (!mounted) return;
    if (created is PetDetail) {
      await ref.read(listPetDetailProvider.notifier).upsertPet(created);
    } else if (created == true) {
      await ref.read(listPetDetailProvider.notifier).refresh();
    }
  }

  Future<void> _refreshHome() async {
    await Future.wait([
      ref.read(listPetDetailProvider.notifier).refresh(),
      ref.read(momentsProvider.notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final momentsAsync = ref.watch(momentsProvider);
    final petsAsync = ref.watch(listPetDetailProvider);
    return CustomScaffold(
      extendBody: true,
      backgroundColor: AppColors.white,
      body: SafeAreaTopOnly(
        child: Padding(
          padding: EdgeInsets.only(bottom: MQ.bottomPadding(context)),
          child: RefreshIndicator(
            color: AppColors.greenStrong1,
            backgroundColor: AppColors.white,
            notificationPredicate: (notification) {
              if (notification.metrics.axis != Axis.vertical) return false;
              if (!_nestedScrollController.hasClients) return true;
              final position = _nestedScrollController.position;
              return position.pixels <= position.minScrollExtent + 0.5;
            },
            onRefresh: _refreshHome,
            child: NestedScrollView(
              controller: _nestedScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              headerSliverBuilder: (_, __) => [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      SC.sw(16),
                      SC.sh(16),
                      SC.sw(16),
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: SC.sh(4),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Boss của bạn',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700,
                                    fontSize: SC.sf(20),
                                    height: 1,
                                    color: AC.blackText4,
                                  ),
                                ),
                              ),
                              TapEffect(
                                onTap: () {
                                  ref
                                          .read(
                                            mainNavigationIndexProvider
                                                .notifier,
                                          )
                                          .state =
                                      1;
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Quản lý',
                                      style: TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w700,
                                        fontSize: SC.sf(14),
                                        height: 22 / 14,
                                        color: AC.neutralPrimaryText,
                                      ),
                                    ),
                                    SizedBox(width: SC.sw(8)),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: SC.smin(16),
                                      color: AC.neutralPrimaryText,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _HomeBossPetsCarousel(
                          petsAsync: petsAsync,
                          onTapAddPet: _onTapAddPet,
                          onPetUpdated: (updated) async {
                            await ref
                                .read(listPetDetailProvider.notifier)
                                .upsertPet(updated);
                          },
                          onRetry: () async {
                            await ref
                                .read(listPetDetailProvider.notifier)
                                .refresh();
                          },
                        ),
                        SizedBox(height: SC.sh(16)),
                        Text(
                          'Dòng kỷ niệm',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                            fontSize: SC.sf(20),
                            height: 1,
                            color: AC.blackText4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              body: MomentsListView(
                momentsAsync: momentsAsync,
                userAvatar: _userAvatar,
                enablePullToRefresh: false,
                onCreateMoment: () async {
                  final created = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const MomentFormScreen(showMomentTypePicker: false),
                    ),
                  );
                  if (created == true && mounted) {
                    await ref.read(momentsProvider.notifier).refresh();
                  }
                },
                onRefresh: _refreshHome,
                onEditMoment: (moment) async {
                  final changed = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MomentFormScreen(
                        existingMoment: moment,
                        showMomentTypePicker: false,
                      ),
                    ),
                  );
                  if (changed == true) {
                    await ref.read(momentsProvider.notifier).refresh();
                  }
                },
                onDeleteMoment: (moment) async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Xóa kỷ niệm?'),
                      content: const Text('Bạn có chắc muốn xóa kỷ niệm này?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Xóa'),
                        ),
                      ],
                    ),
                  );
                  if (confirm != true) return;
                  final resp = await MomentRemoteService.deleteMoment(
                    moment.id,
                  );
                  if (!context.mounted) return;
                  if (resp.isSuccess) {
                    await ref
                        .read(momentsProvider.notifier)
                        .deleteMoment(moment.id);
                  } else {
                    ToastOverlay.show(
                      context,
                      resp.message ?? 'Xóa kỷ niệm thất bại',
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBossPetsCarousel extends StatelessWidget {
  const _HomeBossPetsCarousel({
    required this.petsAsync,
    required this.onTapAddPet,
    required this.onPetUpdated,
    required this.onRetry,
  });

  final AsyncValue<List<PetDetail>> petsAsync;
  final VoidCallback onTapAddPet;
  final ValueChanged<PetDetail> onPetUpdated;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final cardHeight = SC.sh(216);
    final addCardHeight = SC.sh(200);
    final addCardVerticalGap = ((cardHeight - addCardHeight) / 2).clamp(
      0.0,
      double.infinity,
    );
    final verticalShadowSpace = SC.sh(12);
    return SizedBox(
      height: cardHeight + (verticalShadowSpace * 2),
      child: petsAsync.when(
        loading: () => const Center(
          child: TextLoadingIndicator(text: 'Đang tải danh sách thú cưng...'),
        ),
        error: (_, __) => Center(
          child: GestureDetector(
            onTap: onRetry,
            child: Text(
              'Không tải được danh sách, bấm để thử lại',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w600,
                fontSize: SC.sf(12),
                color: AppColors.greenStrong1,
              ),
            ),
          ),
        ),
        data: (pets) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            padding: EdgeInsets.symmetric(vertical: verticalShadowSpace),
            itemCount: pets.length + 1,
            separatorBuilder: (_, __) => SizedBox(width: SC.sw(12)),
            itemBuilder: (_, index) {
              if (index == 0) {
                return SizedBox(
                  width: SC.sw(138),
                  child: Column(
                    children: [
                      SizedBox(height: addCardVerticalGap),
                      AddPetIntroCard(
                        onTap: onTapAddPet,
                        height: addCardHeight,
                      ),
                      SizedBox(height: addCardVerticalGap),
                    ],
                  ),
                );
              }
              final pet = pets[index - 1];
              return SizedBox(
                width: SC.sw(165.5),
                child: PetProfileCard(pet: pet, onPetUpdated: onPetUpdated),
              );
            },
          );
        },
      ),
    );
  }
}
