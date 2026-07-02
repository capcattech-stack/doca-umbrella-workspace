import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:capcat_doca/widgets/image/rectangle_cached_network_image.dart';
import 'package:capcat_doca/widgets/shared/text_with_horizontal_lines.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';

class SharePetProfileScreen extends ConsumerWidget {
  const SharePetProfileScreen({
    super.key,
    this.petQrUrl,
    this.petCoverImageUrl,
    required this.petName,
  });

  final String? petQrUrl;
  final String? petCoverImageUrl;
  final String petName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulletSize = 99.0;
    final bulletInner = 79.0;
    final borderRadius = Radius.circular(14);
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 24.0;
    final contentWidth = screenWidth - padding * 2;
    return AssistantVisibilityScope.hide(
      child: CustomScaffold(
        body: SafeAreaTopOnly(
          child: Column(
            children: [
              CustomAppHeader(
                title: AppLocalizations.of(context)!.sharePetProfileTitle,
                subtitle: petName,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(padding),
                  child: Column(
                    children: [
                      SizedBox(height: bulletSize / 2),
                      PhysicalModel(
                        color: Colors.transparent,
                        shadowColor: Colors.black.withOpacity(0.1),
                        elevation: 8,
                        borderRadius: BorderRadius.circular(14),
                        clipBehavior: Clip.none,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // --- QR card container ---
                            RepaintBoundary(
                              child: Container(
                                width: double.infinity,
                                height: 369,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: bulletSize / 2),
                                    SizedBox(
                                      width: 60,
                                      height: 30,
                                      child: Text(
                                        petName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          height: 30 / 20,
                                          color: AC.blackText5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: padding),
                                    RectangleCachedNetworkImage(
                                      imageUrl: petQrUrl,
                                      width: 230,
                                      height: 230,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // --- Bullet white background ---
                            Positioned(
                              top: -bulletSize / 2,
                              left: (contentWidth - bulletSize) / 2,
                              child: Container(
                                width: bulletSize,
                                height: bulletSize,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            // --- Avatar ---
                            Positioned(
                              top: -bulletSize / 2,
                              left: (contentWidth - bulletSize) / 2,
                              child: RepaintBoundary(
                                child: Container(
                                  width: bulletSize,
                                  height: bulletSize,
                                  alignment: Alignment.center,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minWidth: bulletInner,
                                      minHeight: bulletInner,
                                      maxWidth: bulletInner,
                                      maxHeight: bulletInner,
                                    ),
                                    child: Center(
                                      child: CircleCachedNetworkImage(
                                        imageUrl: petCoverImageUrl!,
                                        size: bulletInner,
                                        subject: ImageSubject.pet,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: padding),
                      TextWithHorizontalLines(
                        text: AppLocalizations.of(context)!.sharePetProfileOr,
                      ),
                      SizedBox(height: padding),
                      Container(
                        width: 327,
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(12, 26, 75, 0.08),
                              blurRadius: 5,
                              offset: Offset(0, 0),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(50, 50, 71, 0.04),
                              blurRadius: 20,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text container
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 247,
                                  height: 20,
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.sharePetProfileShareLink,
                                    style: const TextStyle(
                                      // fontFamily: 'Noto Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 20 / 14,
                                      color: AC.blackText5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            // Action Button (share icon)
                            GestureDetector(
                              onTap: () {
                                ToastOverlay.show(
                                  context,
                                  AppLocalizations.of(
                                    context,
                                  )!.sharePetProfileComingSoon,
                                );
                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Image.asset(
                                  'assets/icons/chia-se-lien-ket.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
