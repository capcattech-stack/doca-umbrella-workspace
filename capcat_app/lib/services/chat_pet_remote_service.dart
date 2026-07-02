import 'package:capcat_doca/models/chat_pet.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';
import 'package:capcat_doca/services/model/service_response.dart';

class ChatPetRemoteService {
  static Future<ServiceResponse<List<ChatPet>>> getChatPets() async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }

    try {
      final response = await ApiService.getChatPets(token);
      final rawBody = response.data;
      final serverMessage = _extractMessage(rawBody);

      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: serverMessage ?? 'Không tải được danh sách bé cưng',
        );
      }

      if (rawBody is! Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phản hồi từ server không hợp lệ',
        );
      }

      final data = rawBody['data'];
      if (data is! List) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Danh sách bé cưng không hợp lệ',
        );
      }

      final pets = data
          .whereType<Map<String, dynamic>>()
          .map(ChatPet.fromJson)
          .toList(growable: false);

      return ServiceResponse(isSuccess: true, data: pets);
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
