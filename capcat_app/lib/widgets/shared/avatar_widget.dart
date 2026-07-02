import 'package:flutter/material.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';

class AvatarWidget extends StatelessWidget {
  final bool isPet;
  final String? imageUrl;
  final double size;
  final String? editIconPath;
  final VoidCallback? onEditTap;

  AvatarWidget({
    super.key,
    required this.isPet,
    this.imageUrl,
    double? size,
    this.editIconPath,
    this.onEditTap,
  }) : size = size ?? SC.smin(80);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              //--Avatar
              CircleCachedNetworkImage(
                imageUrl: imageUrl,
                size: size,
                subject: isPet ? ImageSubject.pet : ImageSubject.person,
              ),
              //--Edit icon
              if (editIconPath != null)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: TapEffect(
                    effect: TapEffectType.both,
                    onTap: onEditTap,
                    child: Image.asset(
                      editIconPath!,
                      height: size * 0.3,
                      width: size * 0.3,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
