import 'package:flutter/material.dart';
import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/image/rectangle_cached_network_image.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';

class PetGallery extends StatelessWidget {
  const PetGallery({super.key, required this.pet});
  final PetDetail pet;

  @override
  Widget build(BuildContext context) {
    final bool showProgressBar = false;
    final bool showPetIdTagButton = false;
    return SizedBox(
      height: SC.sh(250.09),
      width: double.infinity,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: pet.avatarUrl != null
                ? RectangleCachedNetworkImage(
                    imageUrl: pet.avatarUrl!,
                    width: double.infinity,
                    height: double.infinity,
                    radius: 0,
                    fit: BoxFit.cover,
                    subject: ImageSubject.pet,
                  )
                : Image.asset('assets/images/pet-placeholder.png'),
          ),

          // Progress Bar
          if (showProgressBar)
            Positioned(
              top: SC.sh(185),
              left: SC.sw(88),
              width: SC.sw(200),
              height: SC.sh(6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: SC.sw(32),
                    height: SC.sh(3),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 223, 230, 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: SC.sw(6)),
                  Expanded(
                    child: Container(
                      // width: 35,
                      height: SC.sh(6),
                      decoration: BoxDecoration(
                        color: AC.white,
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(color: Colors.white, width: 6),
                      ),
                    ),
                  ),
                  SizedBox(width: SC.sw(6)),
                  // Default border 2
                  Container(
                    width: SC.sw(32),
                    height: SC.sh(3),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 223, 230, 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: SC.sw(6)),
                  Container(
                    width: SC.sw(32),
                    height: SC.sh(3),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 223, 230, 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: SC.sw(6)),
                  Container(
                    width: SC.sw(32),
                    height: SC.sh(3),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 223, 230, 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),

          //--Pet ID Tag button
          if (showPetIdTagButton)
            Positioned(
              top: SC.sh(132),
              right: 0,
              width: SizeConfig.sw(132),
              height: SizeConfig.sh(43),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: SC.sh(4),
                  horizontal: SC.sw(8),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    bottomLeft: Radius.circular(60),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  // No blur (backdrop-filter) due to limited support
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Frame 2833 image icon
                    SizedBox(
                      //width: 32,
                      height: 35,
                      child: Image.asset(
                        'assets/images/pet-id-tag.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Pet ID tag text
                    const SizedBox(
                      //width: 68,
                      height: 22,
                      child: Text(
                        'Pet ID Tag',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 22 / 14,
                          color: AC.neutralDialogTitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
