import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/models/product.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/image/rectangle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/product_item.dart';

class ChatProductsBubble extends StatelessWidget {
  const ChatProductsBubble({
    super.key,
    required this.products,
    required this.maxWidth,
    required this.backgroundColor,
    required this.timeLabel,
    required this.timeColor,
  });

  final List<Product> products;
  final double maxWidth;
  final Color backgroundColor;
  final String timeLabel;
  final Color timeColor;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.fromLTRB(SC.sw(16), SC.sh(16), SC.sw(16), SC.sh(8)),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductsCarousel(context),
            SizedBox(height: SC.sh(6)),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: SC.sf(12),
                  color: timeColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsCarousel(BuildContext context) {
    final double itemWidth = SC.sw(120);
    final double itemHeight = SC.sh(170);

    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (_, __) => SizedBox(width: SC.sw(10)),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(width: itemWidth, child: ProductItem(product: product));
        },
      ),
    );
  }
}

class ChatImagesBubble extends StatelessWidget {
  const ChatImagesBubble({
    super.key,
    required this.imageUrls,
    required this.maxWidth,
    required this.backgroundColor,
    this.onTapImage,
    required this.timeLabel,
    required this.timeColor,
    this.caption,
    this.captionColor,
  });

  final List<String> imageUrls;
  final double maxWidth;
  final Color backgroundColor;
  final ValueChanged<String>? onTapImage;
  final String timeLabel;
  final Color timeColor;
  final String? caption;
  final Color? captionColor;

  @override
  Widget build(BuildContext context) {
    final displayedImages = imageUrls.take(9).toList();
    final remaining = imageUrls.length - displayedImages.length;
    final double spacingH = SC.smin(1);
    final double spacingV = SC.smin(1);
    final double imageEdgeInsetH = SC.smin(1);
    final double imageEdgeInsetV = SC.smin(1);
    final double desiredTextPadding = SC.smin(16);
    final double textInset = desiredTextPadding > imageEdgeInsetH
        ? desiredTextPadding - imageEdgeInsetH
        : 0;

    final bool hasCaption = caption != null;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          imageEdgeInsetH,
          imageEdgeInsetV,
          imageEdgeInsetH,
          caption == null ? imageEdgeInsetV : SC.smin(6),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasCaption)
              Stack(
                children: [
                  _PhotoMosaicLayout(
                    images: displayedImages,
                    spacingH: spacingH,
                    spacingV: spacingV,
                    maxWidth: maxWidth,
                    remainingCount: remaining,
                    onTapImage: onTapImage,
                    clipBottomCorners: true,
                  ),
                  Positioned(
                    right: SC.smin(8),
                    bottom: SC.smin(8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SC.smin(8),
                          vertical: SC.smin(2),
                        ),
                        child: Text(
                          timeLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: SC.sf(12),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else ...[
              _PhotoMosaicLayout(
                images: displayedImages,
                spacingH: spacingH,
                spacingV: spacingV,
                maxWidth: maxWidth,
                remainingCount: remaining,
                onTapImage: onTapImage,
                clipBottomCorners: false,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SC.smin(16),
                  left: textInset,
                  right: textInset,
                ),
                child: Text(
                  caption!,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                    fontSize: SC.sf(14),
                    color: captionColor ?? Colors.black,
                  ),
                ),
              ),
              SizedBox(height: spacingV),
              Padding(
                padding: EdgeInsets.only(left: textInset, right: textInset),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    timeLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(12),
                      color: timeColor,
                    ),
                  ),
                ),
              ),
            ],
            if (hasCaption) SizedBox(height: spacingV),
          ],
        ),
      ),
    );
  }
}

class _PhotoMosaicLayout extends StatelessWidget {
  const _PhotoMosaicLayout({
    required this.images,
    required this.spacingH,
    required this.spacingV,
    required this.maxWidth,
    required this.remainingCount,
    this.onTapImage,
    required this.clipBottomCorners,
  });

  final List<String> images;
  final double spacingH;
  final double spacingV;
  final double maxWidth;
  final int remainingCount;
  final ValueChanged<String>? onTapImage;
  final bool clipBottomCorners;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    final count = images.length;

    Widget layout;
    if (count == 1) {
      layout = _buildSingle(images.first);
    } else if (count == 2) {
      layout = _buildDoubleColumn(images);
    } else if (count == 3) {
      layout = _buildMosaicThree(
        left: images[0],
        topRight: images[1],
        bottomRight: images[2],
      );
    } else if (count == 4) {
      layout = _buildGrid(images, columns: 2);
    } else {
      layout = _buildGrid(images, columns: 3);
    }

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: clipBottomCorners ? const Radius.circular(16) : Radius.zero,
      bottomRight: clipBottomCorners ? const Radius.circular(16) : Radius.zero,
    );

    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: layout,
    );
  }

  Widget _buildSingle(String url) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: _ImageTile(
        url: url,
        onTap: onTapImage,
        isLast: true,
        remainingCount: remainingCount,
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  Widget _buildDoubleColumn(List<String> urls) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: _ImageTile(
            url: urls[0],
            onTap: onTapImage,
            borderRadius: BorderRadius.zero,
            isLast: false,
            remainingCount: remainingCount,
          ),
        ),
        SizedBox(height: spacingV),
        AspectRatio(
          aspectRatio: 4 / 3,
          child: _ImageTile(
            url: urls[1],
            onTap: onTapImage,
            isLast: true,
            remainingCount: remainingCount,
            borderRadius: BorderRadius.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildMosaicThree({
    required String left,
    required String topRight,
    required String bottomRight,
  }) {
    final double targetHeight = maxWidth * 0.7;
    return SizedBox(
      height: targetHeight,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(right: spacingH),
              child: _ImageTile(
                url: left,
                onTap: onTapImage,
                borderRadius: BorderRadius.zero,
                isLast: false,
                remainingCount: remainingCount,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: spacingV),
                    child: _ImageTile(
                      url: topRight,
                      onTap: onTapImage,
                      borderRadius: BorderRadius.zero,
                      isLast: false,
                      remainingCount: remainingCount,
                    ),
                  ),
                ),
                Expanded(
                  child: _ImageTile(
                    url: bottomRight,
                    onTap: onTapImage,
                    isLast: true,
                    remainingCount: remainingCount,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<String> urls, {required int columns}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double tileWidth = (width - spacingH * (columns - 1)) / columns;
        return Wrap(
          spacing: spacingH,
          runSpacing: spacingV,
          children: [
            for (int i = 0; i < urls.length; i++)
              SizedBox(
                width: tileWidth,
                height: tileWidth,
                child: _ImageTile(
                  url: urls[i],
                  onTap: onTapImage,
                  isLast: i == urls.length - 1,
                  remainingCount: remainingCount,
                  borderRadius: BorderRadius.zero,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.url,
    required this.onTap,
    required this.remainingCount,
    required this.isLast,
    required this.borderRadius,
  });

  final String url;
  final ValueChanged<String>? onTap;
  final int remainingCount;
  final bool isLast;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final showOverlay = isLast && remainingCount > 0;

    return GestureDetector(
      onTap: () => onTap?.call(url),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImageContent(),
            if (showOverlay)
              Container(
                color: Colors.black45,
                alignment: Alignment.center,
                child: Text(
                  '+$remainingCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: SC.sf(20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    if (url.startsWith('http')) {
      return RectangleCachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        radius: SC.smin(16),
        subject: ImageSubject.others,
      );
    }
    return Image.file(File(url), fit: BoxFit.cover);
  }
}
