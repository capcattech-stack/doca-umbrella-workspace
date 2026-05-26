import 'package:flutter_chat_mock_app/models/conversation.dart';
import 'package:flutter_chat_mock_app/services/conversation_list_remote_service.dart';
import 'package:flutter_chat_mock_app/storage/conversation_list_local_storage.dart';

class ConversationListRepository {
  final ConversationListLocalStorage local;
  final Duration ttl;

  ConversationListRepository({
    required this.local,
    this.ttl = const Duration(minutes: 5),
  });

  Future<({List<Conversation> localConversations, bool shouldRefresh})>
      getLocalWithPolicy() async {
    final conversations = await local.read();
    final fetchedAt = await local.readFetchedAt();
    final isStale =
        fetchedAt == null || DateTime.now().difference(fetchedAt) > ttl;
    return (localConversations: conversations, shouldRefresh: isStale);
  }

  Future<List<Conversation>> refreshRemote({String? agentType}) async {
    final response = await ConversationListRemoteService.getMyConversations(
      agentType: agentType,
    );
    if (response.isSuccess && response.data != null) {
      final conversations = response.data!;
      await local.save(conversations);
      return conversations;
    }
    throw Exception(
      response.message ?? 'Không tải được danh sách cuộc trò chuyện',
    );
  }

  Future<void> cache(List<Conversation> conversations) =>
      local.save(conversations);

  Future<void> clear() => local.clear();
}
