import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/image/rectangle_cached_network_image.dart';

class ChatAttachmentPreview extends StatelessWidget {
  const ChatAttachmentPreview({
    super.key,
    required this.urls,
    required this.onRemove,
  });

  final List<String> urls;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final itemSize = SC.smin(64);
    return Wrap(
      spacing: SC.sw(8),
      runSpacing: SC.sh(8),
      children: List.generate(urls.length, (index) {
        final url = urls[index];
        return Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: RectangleCachedNetworkImage(
                imageUrl: url,
                width: itemSize,
                height: itemSize,
                radius: 12,
                subject: ImageSubject.others,
              ),
            ),
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  width: SC.smin(20),
                  height: SC.smin(20),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
