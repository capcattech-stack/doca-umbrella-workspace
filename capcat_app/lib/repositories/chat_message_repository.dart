import 'package:flutter_chat_mock_app/models/chat_messages_page.dart';
import 'package:flutter_chat_mock_app/services/chat_message_remote_service.dart';

class ChatMessageRepository {
  Future<ChatMessagesPage> fetchConversationMessages({
    required String conversationId,
    int? cursor,
    int limit = 30,
    String? currentAccountId,
    String? parentId,
  }) async {
    final response = await ChatMessageRemoteService.getConversationMessages(
      conversationId: conversationId,
      cursor: cursor,
      limit: limit,
      currentAccountId: currentAccountId,
      parentId: parentId,
    );

    if (response.isSuccess && response.data != null) {
      return response.data!;
    }

    throw Exception(response.message ?? 'Không tải được danh sách tin nhắn');
  }
}
