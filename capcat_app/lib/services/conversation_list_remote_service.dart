import 'package:capcat_doca/models/conversation.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';
import 'package:capcat_doca/services/model/service_response.dart';

class ConversationListRemoteService {
  static Future<ServiceResponse<List<Conversation>>> getMyConversations({
    int page = 1,
    int limit = 20,
    String? agentType,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }

    try {
      final response = await ApiService.getChatConversations(
        token,
        page: page,
        limit: limit,
        agentType: agentType,
      );
      final rawBody = response.data;
      final serverMessage = _extractMessage(rawBody);

      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: serverMessage ?? 'Không tải được danh sách cuộc trò chuyện',
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
          message: 'Danh sách cuộc trò chuyện không hợp lệ',
        );
      }

      final conversations = data
          .whereType<Map<String, dynamic>>()
          .map(Conversation.fromJson)
          .toList();

      conversations.sort(_conversationComparator);

      return ServiceResponse(isSuccess: true, data: conversations);
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static int _conversationComparator(Conversation a, Conversation b) {
    final aTime = a.lastMessageAt ?? a.updatedAt ?? a.createdAt;
    final bTime = b.lastMessageAt ?? b.updatedAt ?? b.createdAt;
    if (aTime != null && bTime != null) {
      return bTime.compareTo(aTime);
    }
    if (aTime != null) return -1;
    if (bTime != null) return 1;
    return b.id.compareTo(a.id);
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
