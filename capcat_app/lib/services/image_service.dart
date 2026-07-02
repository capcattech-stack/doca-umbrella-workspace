import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:capcat_doca/enums/image_upload_purpose.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';
import 'package:capcat_doca/services/model/service_response.dart';
import 'package:capcat_doca/utils/image_utils.dart';

class ImageService {
  /// Upload một ảnh từ local path với presigned URL (tự xác định mime).
  static Future<UploadImageResult> uploadImageFromPath({
    required String imagePath,
    required ImageUploadPurpose purpose,
  }) async {
    final String? mimeType = ImageUtils.getMimeType(imagePath);
    if (mimeType == null) {
      return UploadImageResult.failure('Không xác định được định dạng ảnh');
    }

    final ServiceResponse getUploadUrlResponse =
        await ImageService.getUploadUrl(purpose, mimeType);
    if (!getUploadUrlResponse.isSuccess ||
        getUploadUrlResponse.data == null ||
        getUploadUrlResponse.data is! Map<String, dynamic>) {
      return UploadImageResult.failure(
        getUploadUrlResponse.message ?? 'Không lấy được upload URL từ server',
      );
    }

    final Map<String, dynamic> responseData =
        getUploadUrlResponse.data as Map<String, dynamic>;
    final String? uploadUrl = responseData['upload_url'];
    final String? fileUrl = responseData['file_url'];
    if (uploadUrl == null || fileUrl == null) {
      return UploadImageResult.failure('Thiếu thông tin upload hoặc file URL');
    }

    final ServiceResponse uploadImageResponse = await ImageService.uploadImage(
      imagePath: imagePath,
      uploadUrl: uploadUrl,
    );
    if (!uploadImageResponse.isSuccess) {
      return UploadImageResult.failure(
        uploadImageResponse.message ?? 'Tải ảnh lên thất bại',
      );
    }

    return UploadImageResult.success(fileUrl);
  }

  static Future<ServiceResponse> uploadImage({
    required String imagePath,
    required String uploadUrl,
    Map<String, String>? headers,
  }) async {
    try {
      final mimeType = ImageUtils.getMimeType(imagePath);
      if (mimeType == null) {
        throw Exception('Không xác định được định dạng của ảnh');
      }
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phiên đăng nhập đã hết hạn',
        );
      }
      final bytes = await File(imagePath).readAsBytes();

      final response = await ApiService.uploadImage(
        token,
        uploadUrl,
        mimeType,
        bytes,
      );

      debugPrint(response.toString());

      if (response.isSuccess) {
        return ServiceResponse(isSuccess: true);
      }
      final message =
          _getSafeMessage(response.data) ??
          'Tải ảnh lên thất bại, vui lòng thử lại sau';
      return ServiceResponse(isSuccess: false, message: message);
    } catch (e) {
      debugPrint('[ImageService.getUploadUrl] Server error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Tải ảnh lên thất bại, vui lòng thử lại sau',
      );
    }
  }

  static Future<ServiceResponse> getUploadUrl(
    ImageUploadPurpose imageUploadPurpose,
    String mimeType,
  ) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phiên đăng nhập đã hết hạn',
        );
      }
      final response = await ApiService.getUploadUrl(
        token,
        imageUploadPurpose,
        mimeType,
      );
      debugPrint(
        '[ImageService.getUploadUrl] ${response.statusCode} ${response.data}',
      );
      if (response.isSuccess) {
        final data = response.data['data'];
        return ServiceResponse(
          isSuccess: true,
          data: data as Map<String, dynamic>,
        );
      }
      final message =
          _getSafeMessage(response.data) ??
          'Tạo đường dẫn thất bại, vui lòng thử lại sau';
      return ServiceResponse(isSuccess: false, message: message);
    } catch (e) {
      debugPrint('[ImageService.getUploadUrl] Server error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Tạo đường dẫn thất bại, vui lòng thử lại sau',
      );
    }
  }

  static Future<ServiceResponse<List<Map<String, dynamic>>>> getUploadUrlsMultiple(
    ImageUploadPurpose purpose,
    List<String> mimeTypes,
  ) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phiên đăng nhập đã hết hạn',
        );
      }
      final response = await ApiService.getUploadUrlsMultiple(
        token,
        purpose,
        mimeTypes,
      );
      debugPrint(
        '[ImageService.getUploadUrlsMultiple] ${response.statusCode} ${response.data}',
      );
      if (response.isSuccess) {
        final data = response.data['data'];
        if (data is List) {
          return ServiceResponse(
            isSuccess: true,
            data: data.whereType<Map<String, dynamic>>().toList(),
          );
        }
      }
      final message =
          _getSafeMessage(response.data) ??
          'Tạo đường dẫn thất bại, vui lòng thử lại sau';
      return ServiceResponse(isSuccess: false, message: message);
    } catch (e) {
      debugPrint('[ImageService.getUploadUrlsMultiple] $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Tạo đường dẫn thất bại, vui lòng thử lại sau',
      );
    }
  }

  static String? _getSafeMessage(dynamic data) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return null;
  }
}
