import 'dart:io';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class ImageUtils {
  static final String petPlaceholderImage = 'assets/images/pet-placeholder.png';

  static String? getMimeType(String filePath) {
    return lookupMimeType(filePath);
  }

  /// Đọc EXIF để lấy GPS + thời gian chụp (nếu có).
  static Future<PhotoInfo?> readPhotoInfo(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final data = await readExifFromBytes(bytes);
      if (data.isEmpty) return null;

      debugPrint('📸 EXIF keys: ${data.keys.join(', ')}');

      double? lat;
      double? lon;
      final gpsLatTag = _findTag(data, ['GPS GPSLatitude', 'GPSLatitude']);
      final gpsLonTag = _findTag(data, ['GPS GPSLongitude', 'GPSLongitude']);
      final gpsLatValues = _extractGpsValues(gpsLatTag);
      final gpsLonValues = _extractGpsValues(gpsLonTag);
      final gpsLatRef = _findTag(data, [
        'GPS GPSLatitudeRef',
        'GPSLatitudeRef',
      ])?.printable;
      final gpsLonRef = _findTag(data, [
        'GPS GPSLongitudeRef',
        'GPSLongitudeRef',
      ])?.printable;

      if (gpsLatValues != null && gpsLonValues != null) {
        lat = _toDecimal(gpsLatValues);
        lon = _toDecimal(gpsLonValues);
        if (lat != null &&
            gpsLatRef != null &&
            gpsLatRef.toUpperCase() == 'S') {
          lat = -lat;
        }
        if (lon != null &&
            gpsLonRef != null &&
            gpsLonRef.toUpperCase() == 'W') {
          lon = -lon;
        }
      }

      final rawDate = _findTagPrintable(data, [
        'EXIF DateTimeOriginal',
        'DateTimeOriginal',
        'EXIF DateTimeDigitized',
        'DateTimeDigitized',
        'EXIF DateTime',
        'Image DateTime',
        'DateTime',
      ]);
      DateTime? dateTaken = _parseExifDate(rawDate);

      return PhotoInfo(lat: lat, lon: lon, dateTaken: dateTaken);
    } catch (_) {
      return null;
    }
  }

  static IfdTag? _findTag(Map<String, IfdTag> data, List<String> keys) {
    for (final key in keys) {
      final tag = data[key];
      if (tag != null) return tag;
    }
    return null;
  }

  static String? _findTagPrintable(
    Map<String, IfdTag> data,
    List<String> keys,
  ) {
    return _findTag(data, keys)?.printable;
  }

  static List<dynamic>? _extractGpsValues(dynamic tag) {
    final values = tag?.values;
    if (values == null) return null;
    if (values is List) return values;
    if (values is Iterable) return values.toList();
    return null;
  }

  static double? _toDecimal(Iterable<dynamic>? values) {
    if (values == null) return null;
    final list = values.toList(growable: false);
    if (list.length < 3) return null;
    double parse(dynamic v) {
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    final deg = parse(list[0]);
    final min = parse(list[1]);
    final sec = parse(list[2]);
    return deg + (min / 60) + (sec / 3600);
  }

  static DateTime? _parseExifDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    // EXIF format: "yyyy:MM:dd HH:mm:ss"
    String normalized = raw.trim();
    if (normalized.contains(' ')) {
      final parts = normalized.split(' ');
      final datePart = parts[0]
          .replaceFirst(':', '-')
          .replaceFirst(':', '-'); // yyyy-MM-dd
      final timePart = parts.length > 1 ? parts[1] : '00:00:00';
      normalized = '${datePart}T$timePart';
    } else {
      normalized = normalized
          .replaceFirst(':', '-')
          .replaceFirst(':', '-'); // yyyy-MM-dd
    }
    return DateTime.tryParse(normalized);
  }
}

class UploadImageResult {
  final String? fileUrl;
  final String? error;

  const UploadImageResult._({this.fileUrl, this.error});

  factory UploadImageResult.success(String url) =>
      UploadImageResult._(fileUrl: url);

  factory UploadImageResult.failure(String message) =>
      UploadImageResult._(error: message);

  bool get isSuccess => fileUrl != null;
}

class PhotoInfo {
  final double? lat;
  final double? lon;
  final DateTime? dateTaken;

  const PhotoInfo({this.lat, this.lon, this.dateTaken});
}
