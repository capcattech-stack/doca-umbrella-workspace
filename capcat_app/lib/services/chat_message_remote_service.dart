import 'package:capcat_doca/models/chat_messages_page.dart';
import 'package:capcat_doca/models/message.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';
import 'package:capcat_doca/services/model/service_response.dart';

class ChatMessageRemoteService {
  static Future<ServiceResponse<ChatMessagesPage>> getConversationMessages({
    required String conversationId,
    int? cursor,
    int limit = 30,
    String? currentAccountId,
    String? parentId,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      return ServiceResponse(isSuccess: false, message: 'Bạn chưa đăng nhập');
    }

    try {
      final response = await ApiService.getConversationMessages(
        token,
        conversationId: conversationId,
        cursor: cursor,
        limit: limit,
        parentId: parentId,
      );
      final raw = response.data;
      final serverMessage = _extractMessage(raw);

      if (!response.isSuccess) {
        return ServiceResponse(
          isSuccess: false,
          message: serverMessage ?? 'Không tải được tin nhắn',
        );
      }

      if (raw is! Map<String, dynamic>) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phản hồi từ server không hợp lệ',
        );
      }

      final data = raw['data'];
      if (data is! List) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Danh sách tin nhắn không hợp lệ',
        );
      }

      final metadata = raw['metadata'];
      final nextCursor = _castNullableInt(
        metadata is Map<String, dynamic> ? metadata['next_cursor'] : null,
      );
      final hasMore = metadata is Map<String, dynamic>
          ? metadata['has_more'] == true
          : false;

      final messages = data
          .whereType<Map<String, dynamic>>()
          .map(
            (json) =>
                Message.fromJson(json, currentAccountId: currentAccountId),
          )
          .toList();

      return ServiceResponse(
        isSuccess: true,
        data: ChatMessagesPage(
          messages: messages,
          nextCursor: nextCursor,
          hasMore: hasMore,
        ),
      );
    } catch (_) {
      return ServiceResponse(
        isSuccess: false,
        message: 'Không thể kết nối tới máy chủ. Vui lòng thử lại.',
      );
    }
  }

  static String? _extractMessage(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final message = raw['message'];
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

  static int? _castNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
