import 'package:flutter/foundation.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/image_service.dart';
import 'package:capcat_doca/services/model/service_response.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';
import 'package:capcat_doca/utils/image_utils.dart';

class ChatAttachmentService {
  // static Future<ServiceResponse<String>> uploadSingleImage({
  //   required int conversationId,
  //   required String imagePath,
  // }) async {
  //   final mimeType = ImageUtils.getMimeType(imagePath);
  //   if (mimeType == null) {
  //     return ServiceResponse(
  //       isSuccess: false,
  //       message: 'Không xác định được định dạng ảnh',
  //     );
  //   }

  //   final presignedResponse = await _createPresignedUpload(
  //     conversationId: conversationId,
  //     mimeType: mimeType,
  //   );

  //   if (!presignedResponse.isSuccess || presignedResponse.data == null) {
  //     return ServiceResponse(
  //       isSuccess: false,
  //       message: presignedResponse.message ?? 'Không lấy được upload URL',
  //     );
  //   }

  //   final data = presignedResponse.data!;
  //   final uploadUrl = data['upload_url'] as String?;
  //   final fileUrl = data['file_url'] as String?;
  //   if (uploadUrl == null || fileUrl == null) {
  //     return ServiceResponse(
  //       isSuccess: false,
  //       message: 'Phản hồi upload không hợp lệ',
  //     );
  //   }

  //   final uploadResponse = await ImageService.uploadImage(
  //     imagePath: imagePath,
  //     uploadUrl: uploadUrl,
  //   );

  //   if (!uploadResponse.isSuccess) {
  //     return ServiceResponse(
  //       isSuccess: false,
  //       message: uploadResponse.message ?? 'Tải ảnh lên thất bại',
  //     );
  //   }

  //   return ServiceResponse(isSuccess: true, data: fileUrl);
  // }

  // static Future<ServiceResponse<Map<String, dynamic>>> _createPresignedUpload({
  //   required int conversationId,
  //   required String mimeType,
  // }) async {
  //   try {
  //     final token = await AuthService.getToken();
  //     if (token == null) {
  //       return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
  //     }

  //     final response = await ApiService.getChatAttachmentPresignedUpload(
  //       token: token,
  //       conversationId: conversationId,
  //       mimeType: mimeType,
  //     );

  //     debugPrint('[ChatAttachmentService] ${response.statusCode} ${response.data}');

  //     if (response.isSuccess) {
  //       final data = response.data['data'];
  //       if (data is Map<String, dynamic>) {
  //         return ServiceResponse(isSuccess: true, data: data);
  //       }
  //       return ServiceResponse(
  //         isSuccess: false,
  //         message: 'Phản hồi không hợp lệ từ máy chủ',
  //       );
  //     }

  //     return ServiceResponse(
  //       isSuccess: false,
  //       message:
  //           _extractMessage(response.data) ?? 'Không tạo được upload URL',
  //     );
  //   } catch (e) {
  //     debugPrint('[ChatAttachmentService] $e');
  //     return ServiceResponse(
  //       isSuccess: false,
  //       message: 'Không thể kết nối tới máy chủ',
  //     );
  //   }
  // }

  static Future<ServiceResponse<List<String>>> uploadMultipleImages({
    required String conversationId,
    required List<String> imagePaths,
  }) async {
    if (imagePaths.isEmpty) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không có ảnh để tải lên',
      );
    }

    final mimeTypes = <String>[];
    for (final path in imagePaths) {
      final mimeType = ImageUtils.getMimeType(path);
      if (mimeType == null) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Không xác định được định dạng của một ảnh',
        );
      }
      mimeTypes.add(mimeType);
    }

    final presignedResponse = await _createPresignedUploadsBatch(
      conversationId: conversationId,
      mimeTypes: mimeTypes,
    );

    if (!presignedResponse.isSuccess || presignedResponse.data == null) {
      return ServiceResponse(
        isSuccess: false,
        message: presignedResponse.message ?? 'Không lấy được upload URL',
      );
    }

    final uploadEntries = presignedResponse.data!;
    if (uploadEntries.length != imagePaths.length) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Số lượng URL trả về không khớp với số ảnh',
      );
    }

    final uploadedUrls = <String>[];
    for (var i = 0; i < imagePaths.length; i++) {
      final info = uploadEntries[i];
      final uploadUrl = info['upload_url'] as String?;
      final fileUrl = info['file_url'] as String?;
      if (uploadUrl == null || fileUrl == null) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Thiếu thông tin upload cho một ảnh',
        );
      }

      final uploadResult = await ImageService.uploadImage(
        imagePath: imagePaths[i],
        uploadUrl: uploadUrl,
      );

      if (!uploadResult.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: uploadResult.message ?? 'Tải ảnh lên thất bại',
        );
      }

      uploadedUrls.add(fileUrl);
    }

    return ServiceResponse(isSuccess: true, data: uploadedUrls);
  }

  static Future<ServiceResponse<List<Map<String, dynamic>>>>
  _createPresignedUploadsBatch({
    required String conversationId,
    required List<String> mimeTypes,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
      }

      final response = await ApiService.getChatAttachmentPresignedUploads(
        token: token,
        conversationId: conversationId,
        mimeTypes: mimeTypes,
      );

      debugPrint(
        '[ChatAttachmentService][multi] ${response.statusCode} ${response.data}',
      );

      if (response.isSuccess) {
        final data = response.data['data'];
        if (data is List) {
          final mapped = data.whereType<Map<String, dynamic>>().toList(
            growable: false,
          );
          return ServiceResponse(isSuccess: true, data: mapped);
        }
        return ServiceResponse(
          isSuccess: false,
          message: 'Phản hồi không hợp lệ từ máy chủ',
        );
      }

      return ServiceResponse(
        isSuccess: false,
        message: _extractMessage(response.data) ?? 'Không tạo được upload URL',
      );
    } catch (e) {
      debugPrint('[ChatAttachmentService][multi] $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ',
      );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return null;
  }
}
