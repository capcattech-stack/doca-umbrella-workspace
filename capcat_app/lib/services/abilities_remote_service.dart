import 'package:flutter/foundation.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';
import 'package:capcat_doca/services/model/service_response.dart';

class AbilitiesRemoteService {
  static Future<ServiceResponse<dynamic>> sendNumerology({
    required String conversationId,
    required String fullName,
    required String birthdate,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }

    try {
      final response = await ApiService.sendNumerology(
        token: token,
        conversationId: conversationId,
        fullName: fullName,
        birthdate: birthdate,
      );
      debugPrint('🔮 Numerology response: ${response.data}');

      final serverMessage = _extractMessage(response.data);
      if (response.isSuccess) {
        return ServiceResponse(
          isSuccess: true,
          data: response.data,
          message: serverMessage,
        );
      }
      return ServiceResponse(
        isSuccess: false,
        message: serverMessage ?? 'Gửi yêu cầu thất bại, vui lòng thử lại.',
      );
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static Future<ServiceResponse<dynamic>> sendZodiac({
    required String conversationId,
    required String birthdate,
    required List<String> zodiacOptions,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }

    try {
      final response = await ApiService.sendZodiac(
        token: token,
        conversationId: conversationId,
        birthdate: birthdate,
        zodiacOptions: zodiacOptions,
      );

      final serverMessage = _extractMessage(response.data);
      if (response.isSuccess) {
        return ServiceResponse(
          isSuccess: true,
          data: response.data,
          message: serverMessage,
        );
      }
      return ServiceResponse(
        isSuccess: false,
        message: serverMessage ?? 'Gửi yêu cầu thất bại, vui lòng thử lại.',
      );
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static Future<ServiceResponse<dynamic>> sendContentGenerate({
    required String conversationId,
    required String imageUrl,
    required String mood,
    required String style,
    required String length,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }
    try {
      final response = await ApiService.sendContentGenerate(
        token: token,
        conversationId: conversationId,
        imageUrl: imageUrl,
        mood: mood,
        style: style,
        length: length,
      );
      final serverMessage = _extractMessage(response.data);
      if (response.isSuccess) {
        return ServiceResponse(isSuccess: true, data: response.data);
      }
      return ServiceResponse(
        isSuccess: false,
        message: serverMessage ?? 'Gửi yêu cầu thất bại, vui lòng thử lại.',
      );
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static String? _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      final message = body['message'];
      if (message is String) return message;
      if (message is List && message.isNotEmpty) {
        final first = message.first;
        if (first is Map<String, dynamic>) {
          final value = first['value'];
          if (value is String) return value;
        }
      }
    }
    return null;
  }
}
