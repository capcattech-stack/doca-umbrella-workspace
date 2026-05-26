import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/image/rectangle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/viewer/full_screen_gallery_viewer.dart';

/// Reusable screen to display a grid of pictures and view each in fullscreen.
class AllPicturesScreen extends StatelessWidget {
  final List<String> imageUrls;

  const AllPicturesScreen({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return AssistantVisibilityScope.hide(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hình ảnh'),
          backgroundColor: AC.white,
          foregroundColor: AC.blackText1,
          elevation: 0.5,
        ),
        backgroundColor: AC.white,
        body: GridView.builder(
          padding: EdgeInsets.all(SC.smin(4)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: SC.smin(4),
            crossAxisSpacing: SC.smin(4),
            childAspectRatio: 1,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            final url = imageUrls[index];
            return TapEffect(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FullScreenGalleryViewer(
                      imageUrls: imageUrls,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: RectangleCachedNetworkImage(
                imageUrl: url,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                radius: 0,
              ),
            );
          },
        ),
      ),
    );
  }
}
