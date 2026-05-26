import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';

enum ImageSubject { person, pet, others }

class CircleCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final ImageSubject subject;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;

  const CircleCachedNetworkImage({
    super.key,
    this.imageUrl,
    this.size = 80,
    this.subject = ImageSubject.pet,
    this.memCacheWidth,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
  });

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.greyImagePlaceholder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = _buildPlaceholder();
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final resolvedMemWidth = memCacheWidth ?? _toCacheDimension(size, dpr);
    final resolvedMemHeight = memCacheHeight ?? _toCacheDimension(size, dpr);
    final resolvedDiskWidth = maxWidthDiskCache ?? _toCacheDimension(size, dpr);
    final resolvedDiskHeight =
        maxHeightDiskCache ?? _toCacheDimension(size, dpr);

    if (imageUrl == null || imageUrl!.isEmpty) {
      return placeholder;
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fadeInDuration: Duration(milliseconds: 300),
      fadeOutDuration: Duration(milliseconds: 600),
      memCacheWidth: resolvedMemWidth,
      memCacheHeight: resolvedMemHeight,
      maxWidthDiskCache: resolvedDiskWidth,
      maxHeightDiskCache: resolvedDiskHeight,
      imageBuilder: (context, provider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: provider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (_, __) => placeholder,
      errorWidget: (_, __, ___) => placeholder,
    );
  }

  int? _toCacheDimension(double logicalSize, double dpr) {
    if (!logicalSize.isFinite || logicalSize <= 0) return null;
    final px = (logicalSize * dpr).round();
    if (px <= 0) return null;
    return px;
  }
}
