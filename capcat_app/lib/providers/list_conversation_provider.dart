import 'package:flutter_chat_mock_app/models/conversation.dart';
import 'package:flutter_chat_mock_app/repositories/conversation_list_repository.dart';
import 'package:flutter_chat_mock_app/storage/conversation_list_local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _conversationListLocalStorageProvider = Provider(
  (_) => ConversationListLocalStorage(),
);

final _conversationListRepositoryProvider = Provider(
  (ref) => ConversationListRepository(
    local: ref.read(_conversationListLocalStorageProvider),
  ),
);

final listConversationProvider =
    AsyncNotifierProvider<ConversationListController, List<Conversation>>(
      () => ConversationListController(),
    );

class ConversationListController extends AsyncNotifier<List<Conversation>> {
  @override
  Future<List<Conversation>> build() async {
    final repo = ref.read(_conversationListRepositoryProvider);
    final policy = await repo.getLocalWithPolicy();
    final localConversations = policy.localConversations;

    if (localConversations.isEmpty) {
      state = const AsyncLoading();
      try {
        final conversations = await repo.refreshRemote();
        state = AsyncData(conversations);
        return conversations;
      } catch (e, st) {
        state = AsyncError(e, st);
        rethrow;
      }
    }

    state = AsyncData(localConversations);

    if (policy.shouldRefresh) {
      _refreshSilently();
    }

    return localConversations;
  }

  Future<bool> _refreshSilently({String? agentType}) async {
    final repo = ref.read(_conversationListRepositoryProvider);
    final previous = state.value ?? <Conversation>[];
    final result = await AsyncValue.guard(
      () => repo.refreshRemote(agentType: agentType),
    );
    var success = false;
    result.when(
      data: (conversations) {
        success = true;
        state = AsyncData(conversations);
      },
      error: (_, __) => state = AsyncData(previous),
      loading: () {},
    );
    return success;
  }

  Future<void> refresh({String? agentType}) async {
    state = const AsyncLoading();
    final repo = ref.read(_conversationListRepositoryProvider);
    state = await AsyncValue.guard(
      () => repo.refreshRemote(agentType: agentType),
    );
  }

  Future<bool> refreshSilently({String? agentType}) {
    return _refreshSilently(agentType: agentType);
  }

  Future<void> clear() async {
    final repo = ref.read(_conversationListRepositoryProvider);
    await repo.clear();
    state = const AsyncData([]);
  }
}
