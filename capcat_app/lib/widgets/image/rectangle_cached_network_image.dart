import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';

class RectangleCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double radius;
  final ImageSubject subject;
  final BoxFit fit;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;

  const RectangleCachedNetworkImage({
    super.key,
    this.imageUrl,
    this.width = 80,
    this.height = 80,
    this.radius = 16,
    this.subject = ImageSubject.others,
    this.fit = BoxFit.cover,
    this.memCacheWidth,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
  });

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: AppColors.greyImagePlaceholder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = _buildPlaceholder();
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final resolvedMemWidth = memCacheWidth ?? _toCacheDimension(width, dpr);
    final resolvedMemHeight = memCacheHeight ?? _toCacheDimension(height, dpr);
    final resolvedDiskWidth =
        maxWidthDiskCache ?? _toCacheDimension(width, dpr);
    final resolvedDiskHeight =
        maxHeightDiskCache ?? _toCacheDimension(height, dpr);

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
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(image: provider, fit: fit),
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
