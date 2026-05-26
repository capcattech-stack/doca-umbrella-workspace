import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenGalleryViewer extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenGalleryViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: initialIndex);

    return AssistantVisibilityScope.hide(
      child: Scaffold(
        backgroundColor: AC.white,
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              itemCount: imageUrls.length,
              pageController: pageController,
              backgroundDecoration: const BoxDecoration(color: AC.white),
              loadingBuilder: (context, event) {
                final progress =
                    event == null || event.expectedTotalBytes == null
                    ? null
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!;
                return Center(
                  child: CircularProgressIndicator(
                    value: progress,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.8),
                    ),
                  ),
                );
              },
              builder: (context, index) {
                final url = imageUrls[index];
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(url),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white70,
                      size: SC.smin(40),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + SC.sh(16),
              right: SC.sw(16),
              child: TapEffect(
                onTap: () => Navigator.of(context).pop(),
                // child: Container(
                //   padding: EdgeInsets.all(SC.smin(10)),
                //   decoration: BoxDecoration(
                //     color: Colors.black54,
                //     shape: BoxShape.circle,
                //   ),
                //   // child: Icon(
                //   //   Icons.close,
                //   //   color: Colors.white,
                //   //   size: SC.smin(20),
                //   // ),

                // ),
                child: Image.asset(
                  'assets/icons/main-x.png',
                  width: SC.smin(32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
