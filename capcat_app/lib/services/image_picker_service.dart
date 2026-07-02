import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:capcat_doca/widgets/sheets/image_source_sheet.dart';

class PickedImages {
  final List<String> paths;

  /// True khi nên thay thế danh sách ảnh đang có (camera).
  final bool replaceExisting;
  PickedImages({required this.paths, this.replaceExisting = false});
}

/// Centralized picker that shows an action sheet (camera / gallery) and
/// returns local compressed file paths.
class ImagePickerService {
  static Future<PickedImages?> pickImages(
    BuildContext context, {
    bool allowCamera = true,
    bool allowGallery = true,
    bool allowMultiple = true,
  }) async {
    final choice = await showImageSourceSheet(context);
    if (!context.mounted) return null;
    if (choice == null) return null;

    if (choice == ImageSourceOption.gallery) {
      if (!allowGallery) return null;
      return pickFromGallery(context, allowMultiple: allowMultiple);
    }

    // Camera: pick a single image then compress.
    if (!allowCamera) return null;
    return pickFromCamera(context);
  }

  static Future<PickedImages?> pickFromCamera(BuildContext context) async {
    final granted = await _ensureCameraPermission(context);
    if (!granted) return null;
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_${photo.name}';

    final compressed = await FlutterImageCompress.compressAndGetFile(
      photo.path,
      targetPath,
      quality: 70,
    );

    if (compressed == null || !await File(compressed.path).exists()) {
      return null;
    }
    return PickedImages(paths: [compressed.path], replaceExisting: true);
  }

  static Future<PickedImages?> pickFromGallery(
    BuildContext context, {
    bool allowMultiple = true,
  }) async {
    final paths = await _pickGalleryWithImagePicker(allowMultiple);
    if (paths.isEmpty) return null;
    return PickedImages(paths: paths, replaceExisting: false);
  }

  static Future<List<String>> _pickGalleryWithImagePicker(
    bool allowMultiple,
  ) async {
    final picker = ImagePicker();
    final images = allowMultiple
        ? await picker.pickMultiImage()
        : await picker
              .pickImage(source: ImageSource.gallery)
              .then((value) => value == null ? <XFile>[] : <XFile>[value]);
    if (images.isEmpty) return [];

    final tempDir = await getTemporaryDirectory();
    final paths = <String>[];
    for (final img in images) {
      final targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_${img.name}';
      final compressed = await FlutterImageCompress.compressAndGetFile(
        img.path,
        targetPath,
        quality: 70,
      );
      if (compressed != null && await File(compressed.path).exists()) {
        paths.add(compressed.path);
      }
    }
    return paths;
  }

  static Future<bool> _ensureCameraPermission(BuildContext context) async {
    final status = await Permission.camera.request();
    if (status.isGranted) return true;
    if (!context.mounted) return false;
    _handlePermissionDenied(context, status, 'Không có quyền camera');
    return false;
  }

  static void _handlePermissionDenied(
    BuildContext context,
    PermissionStatus status,
    String message,
  ) {
    final isPermanent =
        status.isPermanentlyDenied || status.isRestricted || status.isLimited;
    final text = isPermanent
        ? '$message. Vui lòng mở Cài đặt để cấp quyền.'
        : message;
    ToastOverlay.show(context, text);
  }
}
