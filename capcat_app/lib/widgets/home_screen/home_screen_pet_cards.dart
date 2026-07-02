import 'package:flutter/material.dart';
import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/image_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/transition_config.dart';
import 'package:capcat_doca/widgets/shared/dashed_circle_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';

class HomeScreenPetCards extends ConsumerStatefulWidget {
  const HomeScreenPetCards({super.key});

  @override
  ConsumerState<HomeScreenPetCards> createState() => _PetsScreenPetCardsState();
}

class _PetsScreenPetCardsState extends ConsumerState<HomeScreenPetCards> {
  @override
  Widget build(BuildContext context) {
    final petsAsync = ref.watch(listPetDetailProvider);

    return SizedBox(
      width: SizeConfig.sw(327),
      height: SizeConfig.sh(118),
      child: petsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.greenStrong1),
        ),
        error: (error, _) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            AddNewPetCard(),
          ],
        ),
        data: (petList) {
          final children = [
            ...petList.map((pet) => PetCardItem(pet: pet)),
            const SizedBox(width: 8),
            const AddNewPetCard(),
          ];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
        },
      ),
    );
  }
}

class PetCardItem extends ConsumerWidget {
  final PetDetail pet;
  const PetCardItem({required this.pet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPetId = ref.watch(selectedPetIdProvider);
    final isSelected = selectedPetId == pet.id;
    final double avatarSize = isSelected
        ? SizeConfig.sh(80)
        : SizeConfig.sh(60);

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedPetIdProvider.notifier).state = pet.id;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            width: 84,
            height: SizeConfig.sh(118),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.sh(80),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: TransitionConfig.durationShort,
                      ),
                      curve: Curves.easeInOut,
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: AppColors.greenStrong1,
                                width: 3,
                              )
                            : null,
                      ),
                      child: CircleCachedNetworkImage(
                        imageUrl: pet.avatarUrl,
                        size: avatarSize,
                        subject: ImageSubject.pet,
                      ),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(
                    milliseconds: TransitionConfig.durationShort,
                  ),
                  curve: Curves.easeInOut,
                  child: SizedBox(height: isSelected ? (80 - 60) / 2 : 0),
                ),
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AC.blackText6,
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

class AddNewPetCard extends StatelessWidget {
  const AddNewPetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: SizeConfig.sh(118),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.sh(80),
            child: Center(
              child: RepaintBoundary(
                child: Container(
                  width: SizeConfig.sh(60),
                  height: SizeConfig.sh(60),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AC.peachCardBg,
                  ),
                  child: DashedCircleBorder(
                    size: SizeConfig.sh(60),
                    color: AC.peachAddIconBg,
                    strokeWidth: 2,
                    dashCount: 30,
                    child: const Icon(Icons.add, color: AC.brownAddIcon),
                  ),
                ),
              ),
            ),
          ),
          const Text(
            'Thêm',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AC.blackText6,
            ),
          ),
        ],
      ),
    );
  }
}
