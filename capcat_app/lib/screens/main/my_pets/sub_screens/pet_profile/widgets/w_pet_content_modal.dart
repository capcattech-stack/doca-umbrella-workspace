import 'package:flutter/material.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_profile/widgets/w_pet_scrollable_details.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';

class PetContentModal extends StatelessWidget {
  const PetContentModal({
    super.key,
    required this.onTapEdit,
    this.scrollController,
    required this.sheetController,
    required this.sheetAvailableHeight,
    required this.minSheetSize,
    required this.pet,
  });

  final VoidCallback onTapEdit;
  final ScrollController? scrollController;
  final DraggableScrollableController sheetController;
  final double sheetAvailableHeight;
  final double minSheetSize;
  final PetDetail pet;

  @override
  Widget build(BuildContext context) {
    final double hp = SC.sw(24);
    final double vp = SC.sh(24);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: hp),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          //--From pet Title Group to Tab Selector
          DragToExpandArea(
            sheetController: sheetController,
            sheetAvailableHeight: sheetAvailableHeight,
            minSheetSize: minSheetSize,
            child: Column(
              children: [
                SizedBox(height: vp),
                _PetContentTitle(
                  onTapEdit: onTapEdit,
                  petName: pet.name,
                  petBreed: pet.breed,
                ),
                SizedBox(height: vp),
                _PetProfileTabSelector(),
                SizedBox(height: vp),
              ],
            ),
          ),
          //--From About Pet "Về bé yêu" to end
          Expanded(
            child: PetScrollableDetails(
              scrollController: scrollController,
              pet: pet,
            ),
          ),
        ],
      ),
    );
  }
}

//--Title with Edit button
class _PetContentTitle extends StatelessWidget {
  const _PetContentTitle({
    required this.petName,
    required this.petBreed,
    required this.onTapEdit,
  });

  final VoidCallback onTapEdit;
  final String petName;
  final String petBreed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SC.sh(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SC.sh(30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    petName,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      fontSize: SC.sf(24),
                      color: AC.blackText6,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SC.sh(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    petBreed,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(14),
                      color: AC.greyText4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //--Edit Pet button
          TapEffect(
            onTap: () {
              onTapEdit();
            },
            child: CircleAvatar(
              radius: SC.sh(24),
              backgroundColor: Colors.transparent,
              child: Image.asset(
                'assets/icons/edit-pet.png',
                // height: SC.sh(48),
                // width: SC.sh(48),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetProfileTabSelector extends StatelessWidget {
  const _PetProfileTabSelector();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: SC.sh(42),
      width: double.infinity,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTab(
              width: SC.sw(97),
              height: SC.sh(42),
              backgroundColor: AC.peachModalBg, // #FFD1B8
              borderRadius: 99,
              child: Text(
                l10n.petProfileTabInfo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(14),
                  // height: 22 / 14,
                  color: AC.blackText6,
                ),
              ),
            ),
            // const SizedBox(width: 12),
            // _buildTab(
            //   width: 92,
            //   height: 42,
            //   backgroundColor: AC.greyTab1, // #F6F6F6
            //   borderRadius: 999,
            //   child: Text(
            //     'Sức khỏe',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontFamily: 'Quicksand',
            //       fontWeight: FontWeight.w500,
            //       fontSize: SC.sf(14),
            //       // height: 20 / 14,
            //       color: AC.greyText5,
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 12),
            // _buildTab(
            //   width: 108,
            //   height: 42,
            //   backgroundColor: AC.greyTab1,
            //   borderRadius: 999,
            //   child: Text(
            //     'Dinh dưỡng',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontFamily: 'Quicksand',
            //       fontWeight: FontWeight.w500,
            //       fontSize: SC.sf(14),
            //       height: 20 / 14,
            //       color: AC.greyText5,
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 12),
            // _buildTab(
            //   width: 103,
            //   height: 42,
            //   backgroundColor: AC.greyTab1,
            //   borderRadius: 999,
            //   child: const Text(
            //     'Hoạt động',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontFamily: 'Quicksand',
            //       fontWeight: FontWeight.w500,
            //       fontSize: 14,
            //       height: 20 / 14,
            //       color: AC.greyText5,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required double width,
    required double height,
    required Color backgroundColor,
    required double borderRadius,
    required Widget child,
  }) {
    return Container(
      // width: width,
      height: height,
      padding: EdgeInsets.symmetric(vertical: SC.sh(10), horizontal: SC.sw(16)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(child: child),
    );
  }
}

class DragToExpandArea extends StatelessWidget {
  const DragToExpandArea({
    super.key,
    required this.sheetController,
    required this.sheetAvailableHeight,
    required this.minSheetSize,
    required this.child,
    this.enableSnap = false,
  });

  final DraggableScrollableController sheetController;
  final double sheetAvailableHeight;
  final double minSheetSize;
  final Widget child;
  final bool enableSnap;

  Future<void> _snapIfNeeded() async {
    if (!enableSnap) return;
    final size = sheetController.size;
    final mid = minSheetSize + (1 - minSheetSize) / 2;
    final target = (size >= mid) ? 1.0 : minSheetSize;

    if ((target - size).abs() < 0.001) return;
    await sheetController.animateTo(
      target,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        final dy = details.primaryDelta ?? 0.0;
        if (dy == 0) return;

        // dy < 0: kéo lên -> tăng size; dy > 0: kéo xuống -> giảm size
        final deltaSize = -dy / sheetAvailableHeight;
        final newSize = (sheetController.size + deltaSize).clamp(
          minSheetSize,
          1.0,
        );
        sheetController.jumpTo(newSize);
      },
      onVerticalDragEnd: (_) => _snapIfNeeded(),
      child: child,
    );
  }
}
