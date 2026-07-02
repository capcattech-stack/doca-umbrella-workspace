import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/transition_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenPetInfoCardGrid extends ConsumerWidget {
  const HomeScreenPetInfoCardGrid({super.key});

  Widget buildInfoCard({
    required WidgetRef ref,
    required String iconAsset,
    required String title,
    required String mainValue,
    required String unitOrSub,
    required String date,
  }) {
    // Không cần selectedIndex nữa
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: AC.greyTab1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AC.peachCardBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child: Image.asset(
                    iconAsset,
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AC.neutralPrimaryText,
                ),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(
              milliseconds: TransitionConfig.durationShort,
            ),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Column(
              key: ValueKey(
                mainValue,
              ), // key theo mainValue để fade khi đổi dữ liệu
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      mainValue,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AC.blackText6,
                      ),
                    ),
                    if (unitOrSub.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      unitOrSub == 'Thiết lập'
                          ? GestureDetector(
                              onTap: () {
                                debugPrint('Thiết lập được nhấn');
                              },
                              child: Text(
                                unitOrSub,
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AC.blueInfoAccent,
                                ),
                              ),
                            )
                          : Text(
                              unitOrSub,
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AC.greyText4,
                              ),
                            ),
                    ],
                  ],
                ),
                if (date.isNotEmpty)
                  Text(
                    date,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AC.greyText3,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(listPetDetailProvider);
    final selectedPetId = ref.watch(selectedPetIdProvider);

    return petsAsync.when(
      loading: () => const SizedBox(),
      error: (error, _) => const SizedBox(),
      data: (petList) {
        if (petList.isEmpty || selectedPetId == null) {
          return const SizedBox();
        }

        final currentPet = petList.firstWhere(
          (pet) => pet.id == selectedPetId,
          orElse: () => petList.first,
        );

        final items = [
          buildInfoCard(
            ref: ref,
            iconAsset: 'assets/images/da-o-ben-nhau.png',
            title: 'Đã ở bên nhau',
            mainValue: currentPet.togetherDays?.toString() ?? '-',
            unitOrSub: 'Ngày',
            date: currentPet.adoptedDate ?? '',
          ),
          buildInfoCard(
            ref: ref,
            iconAsset: 'assets/images/sinh-nhat.png',
            title: 'Sinh nhật',
            mainValue: currentPet.daysUntilBirthday?.toString() ?? '-',
            unitOrSub: 'Ngày nữa',
            date: currentPet.birthDate ?? '',
          ),
          buildInfoCard(
            ref: ref,
            iconAsset: 'assets/images/can-nang.png',
            title: 'Cân nặng',
            mainValue: currentPet.weight?.toString() ?? '-',
            unitOrSub: 'kg',
            date: currentPet.weightSince ?? '',
          ),
          buildInfoCard(
            ref: ref,
            iconAsset: 'assets/images/loi-nhac.png',
            title: 'Lời nhắc',
            mainValue: '',
            unitOrSub: 'Thiết lập',
            date: '',
          ),
        ];

        return SizedBox(
          width: SizeConfig.sw(338),
          height: SizeConfig.sh(238),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double itemWidth = (constraints.maxWidth - 8) / 2;
              final double itemHeight = (constraints.maxHeight - 8) / 2;
              final double dynamicAspectRatio = itemWidth / itemHeight;

              return GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                childAspectRatio: dynamicAspectRatio,
                children: items,
              );
            },
          ),
        );
      },
    );
  }
}
