import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({
    super.key,
    this.avatarUrl,
    this.size,
    this.subject = ImageSubject.pet,
    this.fallback,
  });

  final String? avatarUrl;
  final double? size;
  final ImageSubject subject;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? SC.smin(24);
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleCachedNetworkImage(
        imageUrl: avatarUrl!,
        size: resolvedSize,
        subject: subject,
      );
    }

    if (fallback != null) {
      return SizedBox(
        width: resolvedSize,
        height: resolvedSize,
        child: FittedBox(fit: BoxFit.contain, child: fallback),
      );
    }

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.greenStrong1.withAlpha((0.12 * 255).round()),
      ),
      child: Icon(
        Icons.pets,
        color: AC.greenStrong1,
        size: resolvedSize * 0.65,
      ),
    );
  }
}
