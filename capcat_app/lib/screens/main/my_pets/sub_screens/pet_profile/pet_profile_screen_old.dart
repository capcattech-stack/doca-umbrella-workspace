import 'package:flutter/material.dart';
import 'package:capcat_doca/enums/edit_pet_screen_action.dart';
import 'package:capcat_doca/providers/pet_form_providers.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/pet_form_screen.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart'
    show petByIdProvider;

import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_profile/widgets/w_pet_content_modal.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_profile/widgets/w_pet_gallery.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class PetProfileScreenOld extends ConsumerWidget {
  const PetProfileScreenOld({super.key, required this.petId});

  final String petId;

  void _onChildTapEdit(BuildContext context, PetDetail pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProviderScope(
          overrides: [
            petFormDataProvider.overrideWith(
              () => PetFormDataNotifier(initialPet: pet),
            ),
          ],
          child: PetFormScreen(
            action: EditPetScreenAction.edit,
            pet: pet,
            isManual: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double headerHeight = SC.sh(67);
    final double galleryHeight = SC.sh(250.09);
    final PetDetail? pet = ref.watch(petByIdProvider(petId));
    if (pet == null) {
      return CustomScaffold(
        body: SafeAreaTopOnly(
          child: Center(
            child: Text(AppLocalizations.of(context)!.petProfileNotFound),
          ),
        ),
      );
    }

    return CustomScaffold(
      backgroundColor: AC.background,
      body: SafeAreaTopOnly(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenHeight = constraints.maxHeight;

            //--Sheet default position
            final double minSheetTopPosition =
                headerHeight + (galleryHeight * 4 / 5);

            final double minSheetHeight = screenHeight - minSheetTopPosition;

            final double minSheetHeightScale = minSheetHeight / screenHeight;

            final draggableController = DraggableScrollableController();

            final double sheetTitleGroupHeight = SC.sh(50);

            // //--Just enough to hide sheet Title and Subtitle behind screen Header
            final double maxSheetTopPosition =
                headerHeight - sheetTitleGroupHeight - SC.sh(24);

            //--If need to hide Tab Selector, hide additional space of vertical padding
            //below Tab Selector
            // final double maxSheetTopPosition =
            //     headerHeight -
            //     sheetTitleHeight -
            //     sheetSubtitleHeight -
            //     SC.sh(24);

            final double sheetAvailableVerticalMovingSpace =
                screenHeight - maxSheetTopPosition;

            return Stack(
              children: [
                //--Gallery
                Column(
                  children: [
                    SizedBox(height: headerHeight),
                    PetGallery(pet: pet),
                  ],
                ),
                //--The whole Sheet
                Positioned(
                  top: maxSheetTopPosition,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: DraggableScrollableSheet(
                    controller: draggableController,
                    expand: false,
                    initialChildSize: minSheetHeightScale,
                    minChildSize: minSheetHeightScale,
                    maxChildSize: 1.0,
                    builder: (context, scrollController) {
                      return PetContentModal(
                        onTapEdit: () => _onChildTapEdit(context, pet),
                        pet: pet,
                        scrollController: scrollController,
                        sheetController: draggableController,
                        sheetAvailableHeight: sheetAvailableVerticalMovingSpace,
                        minSheetSize: minSheetHeightScale,
                      );
                    },
                  ),
                ),
                CustomAppHeader(title: AppLocalizations.of(context)!.petProfileHeader),
              ],
            );
          },
        ),
      ),
    );
  }
}
