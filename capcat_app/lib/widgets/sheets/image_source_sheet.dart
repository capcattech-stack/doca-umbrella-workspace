import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';

enum ImageSourceOption { camera, gallery }

Future<ImageSourceOption?> showImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<ImageSourceOption>(
    context: context,
    backgroundColor: AC.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SC.sw(16),
            vertical: SC.sh(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OptionTile(
                icon: Icons.photo_camera_outlined,
                label: 'Chụp ảnh',
                onTap: () => Navigator.of(ctx).pop(ImageSourceOption.camera),
              ),
              SizedBox(height: SC.sh(8)),
              _OptionTile(
                icon: Icons.photo_library_outlined,
                label: 'Chọn từ thư viện',
                onTap: () => Navigator.of(ctx).pop(ImageSourceOption.gallery),
              ),
              SizedBox(height: SC.sh(8)),
            ],
          ),
        ),
      );
    },
  );
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AC.white,
      borderRadius: BorderRadius.circular(12),
      child: TapEffect(
        // borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SC.sw(12),
            vertical: SC.sh(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: SC.smin(22), color: AC.neutralIconDark),
              SizedBox(width: SC.sw(12)),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: SC.sf(14),
                  color: AC.blackText6,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                size: SC.smin(18),
                color: AC.neutralPrimaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
