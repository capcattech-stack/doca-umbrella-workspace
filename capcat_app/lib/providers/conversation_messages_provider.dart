import 'package:capcat_doca/models/message.dart';
import 'package:capcat_doca/repositories/chat_message_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef ConversationMessagesArgs = ({
  String conversationId,
  String? currentAccountId,
  String? parentId,
});

final _chatMessageRepositoryProvider = Provider((_) => ChatMessageRepository());

final conversationMessagesProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      ConversationMessagesController,
      List<Message>,
      ConversationMessagesArgs
    >(ConversationMessagesController.new);

class ConversationMessagesController
    extends
        AutoDisposeFamilyAsyncNotifier<
          List<Message>,
          ConversationMessagesArgs
        > {
  late ConversationMessagesArgs _args;
  int? _nextCursor;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  @override
  Future<List<Message>> build(ConversationMessagesArgs args) async {
    _args = args;
    final repo = ref.read(_chatMessageRepositoryProvider);
    final page = await repo.fetchConversationMessages(
      conversationId: args.conversationId,
      currentAccountId: args.currentAccountId,
      parentId: args.parentId,
    );
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;
    return page.messages;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final repo = ref.read(_chatMessageRepositoryProvider);
    try {
      final page = await repo.fetchConversationMessages(
        conversationId: _args.conversationId,
        currentAccountId: _args.currentAccountId,
      );
      _nextCursor = page.nextCursor;
      _hasMore = page.hasMore;
      state = AsyncData(page.messages);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _nextCursor == null) return;
    _isLoadingMore = true;
    final previous = state.value ?? const <Message>[];
    final repo = ref.read(_chatMessageRepositoryProvider);
    final result = await AsyncValue.guard(
      () => repo.fetchConversationMessages(
        conversationId: _args.conversationId,
        cursor: _nextCursor,
        currentAccountId: _args.currentAccountId,
        parentId: _args.parentId,
      ),
    );

    result.when(
      data: (page) {
        _nextCursor = page.nextCursor;
        _hasMore = page.hasMore;
        state = AsyncData([...previous, ...page.messages]);
      },
      error: (_, __) {
        state = AsyncData(previous);
      },
      loading: () {},
    );

    _isLoadingMore = false;
  }

  bool get hasMore => _hasMore;
}
