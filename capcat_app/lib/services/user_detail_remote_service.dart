import 'package:flutter/foundation.dart';
import 'package:flutter_chat_mock_app/models/user_detail.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/extension/response_extension.dart';
import 'package:flutter_chat_mock_app/services/model/service_response.dart';

class UserDetailRemoteService {
  static Future<ServiceResponse> getMyProfile() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: '');
      }
      final response = await ApiService.getMyProfile(token);
      debugPrint(
        '[UserService.getProfile] ${response.statusCode} ${response.data}',
      );

      if (response.isSuccess) {
        final data = response.data['data'];
        final userDetail = UserDetail(
          id: data['id'],
          phoneNumber: data['phone'],
          avatarUrl: data['avatar'],
          email: data['email'],
          fullName: data['full_name'],
          address: data['address'],
          dateOfBirth: data['dob'],
          gender: data['gender'],
        );
        return ServiceResponse<UserDetail>(isSuccess: true, data: userDetail);
      }
      final message =
          _getSafeMessage(response.data) ??
          'Tải dữ liệu thất bại, vui lòng thử lại sau';
      return ServiceResponse(isSuccess: false, message: message);
    } catch (e) {
      debugPrint('[UserService.getProfile] Server error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Tải dữ liệu thất bại, vui lòng thử lại sau',
      );
    }
  }

  static Future<ServiceResponse> updateUserAvatar(
    String avatarFilePath,
    String mimeType,
  ) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
      }

      final response = await ApiService.updateUserAvatar(
        token,
        avatarFilePath,
        mimeType,
      );
      debugPrint('updateUserAvatar: ${response.statusCode}');

      if (response.isSuccess) {
        final data = response.data['data'];
        return ServiceResponse(isSuccess: true, data: data);
      }

      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'] ?? 'Cập nhật ảnh đại diện thất bại',
      );
    } catch (e) {
      debugPrint('updateUserAvatar error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<ServiceResponse<UserDetail>> updateProfile({
    String? fullName,
    String? email,
    String? address,
    String? dateOfBirth,
    String? gender,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phiên đăng nhập đã hết hạn',
        );
      }

      // Chỉ gửi field có giá trị
      final body = <String, dynamic>{};
      if ((fullName ?? '').trim().isNotEmpty) {
        body['full_name'] = fullName!.trim();
      }
      if ((email ?? '').trim().isNotEmpty) {
        body['email'] = email!.trim();
      }
      if ((address ?? '').trim().isNotEmpty) {
        body['address'] = address!.trim();
      }
      if ((dateOfBirth ?? '').trim().isNotEmpty) {
        body['dob'] = dateOfBirth!.trim();
      }
      if ((gender ?? '').trim().isNotEmpty) {
        body['gender'] = gender!.trim();
      }

      if (body.isEmpty) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Không có thay đổi nào để cập nhật',
        );
      }
      debugPrint(body.toString());
      final response = await ApiService.updateMyProfile(body, token);
      debugPrint(
        '[UserService.updateProfile] ${response.statusCode} ${response.data}',
      );

      if (response.isSuccess) {
        final data = response.data['data'];
        final updated = UserDetail(
          id: data['id'],
          phoneNumber: data['phone'],
          avatarUrl: data['avatar'],
          email: data['email'],
          fullName: data['full_name'],
          address: data['address'],
          dateOfBirth: data['dob'],
          gender: data['gender'],
        );
        return ServiceResponse<UserDetail>(isSuccess: true, data: updated);
      }

      final msg =
          _getSafeMessage(response.data) ??
          'Cập nhật thất bại, vui lòng thử lại sau';
      return ServiceResponse(isSuccess: false, message: msg);
    } catch (e) {
      debugPrint('[UserService.updateProfile] Server error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Có lỗi kết nối, vui lòng thử lại sau',
      );
    }
  }

  /// --- Helpers ---
  static String? _getSafeMessage(dynamic data) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return null;
  }
}
