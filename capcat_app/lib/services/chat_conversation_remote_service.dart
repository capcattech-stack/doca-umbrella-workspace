import 'package:flutter_chat_mock_app/models/conversation.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/extension/response_extension.dart';
import 'package:flutter_chat_mock_app/services/model/service_response.dart';

class ChatConversationRemoteService {
  static Future<ServiceResponse<Conversation>> startConversation({
    required String petId,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }

    try {
      final response = await ApiService.startChat(token: token, petId: petId);
      final rawBody = response.data;
      final serverMessage = _extractMessage(rawBody);
      final errorCode = _extractErrorCode(rawBody);

      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: serverMessage ?? 'Không bắt đầu được cuộc trò chuyện',
          errorCode: errorCode,
        );
      }

      if (rawBody is! Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phản hồi từ server không hợp lệ',
        );
      }

      final data = rawBody['data'];
      if (data is! Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Dữ liệu cuộc trò chuyện không hợp lệ',
        );
      }

      final conversation = Conversation.fromJson(data);
      return ServiceResponse(isSuccess: true, data: conversation);
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

  static String? _extractErrorCode(dynamic body) {
    if (body is Map<String, dynamic>) {
      final error = body['error'];
      if (error is String) return error;
    }
    return null;
  }
}
