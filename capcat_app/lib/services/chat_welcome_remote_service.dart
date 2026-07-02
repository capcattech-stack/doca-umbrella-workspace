import 'package:capcat_doca/models/chat_welcome.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';
import 'package:capcat_doca/services/model/service_response.dart';

class ChatWelcomeRemoteService {
  static Future<ServiceResponse<ChatWelcomeContent>> getWelcomeContent() async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }

    try {
      final response = await ApiService.getChatWelcome(token);
      final rawBody = response.data;
      final serverMessage = _extractMessage(rawBody);

      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: serverMessage ?? 'Không tải được nội dung gợi ý',
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
          message: 'Dữ liệu gợi ý không hợp lệ',
        );
      }

      final welcomeContent = ChatWelcomeContent.fromJson(data);
      return ServiceResponse(isSuccess: true, data: welcomeContent);
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
