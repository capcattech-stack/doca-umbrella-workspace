import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:capcat_doca/models/message.dart';
import 'package:capcat_doca/models/nanny_profile.dart';
import 'package:capcat_doca/providers/socket_provider.dart';
import 'package:capcat_doca/repositories/nanny_message_repository.dart';
import 'package:capcat_doca/repositories/nanny_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final _nannyMessageRepositoryProvider = Provider(
  (_) => NannyMessageRepository(),
);
final _nannyProfileRepositoryProvider = Provider(
  (_) => NannyProfileRepository(),
);

final nannyTypingProvider = StateProvider<bool>((_) => false);
final nannyHasUserMessagedRecentlyProvider = StateProvider<bool>((_) => true);
final nannyFocusMessageRequestProvider = StateProvider<String?>((_) => null);

final nannyMessagesProvider =
    AsyncNotifierProvider<NannyMessagesController, List<Message>>(
      NannyMessagesController.new,
    );
final nannyPinnedMessagesProvider = FutureProvider.autoDispose<List<Message>>((
  ref,
) async {
  final repo = ref.read(_nannyMessageRepositoryProvider);
  final page = await repo.fetchNannyMessages(limit: 30, pinnedStatus: 'pinned');
  return page.messages;
});

final nannyProfileProvider =
    AsyncNotifierProvider<NannyProfileController, NannyProfile?>(
      NannyProfileController.new,
    );

class NannyProfileController extends AsyncNotifier<NannyProfile?> {
  static const Duration _ttl = Duration(minutes: 10);
  DateTime? _lastFetchedAt;

  @override
  Future<NannyProfile?> build() async {
    return _loadWithCache();
  }

  bool _isExpired() {
    final lastFetchedAt = _lastFetchedAt;
    if (lastFetchedAt == null) return true;
    return DateTime.now().difference(lastFetchedAt) > _ttl;
  }

  Future<NannyProfile?> _loadWithCache() async {
    final cached = state.value;
    if (cached != null && !_isExpired()) return cached;
    return _fetchRemote();
  }

  Future<NannyProfile?> _fetchRemote() async {
    final repo = ref.read(_nannyProfileRepositoryProvider);
    final profile = await repo.fetchNannyProfile();
    _lastFetchedAt = DateTime.now();
    return profile;
  }

  Future<void> refreshSilently() async {
    final previous = state.value;
    final result = await AsyncValue.guard(_fetchRemote);
    result.when(
      data: (profile) => state = AsyncData(profile),
      error: (_, __) => state = AsyncData(previous),
      loading: () {},
    );
  }
}

class NannyMessagesController extends AsyncNotifier<List<Message>> {
  int? _nextCursor;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  @override
  Future<List<Message>> build() async {
    final repo = ref.read(_nannyMessageRepositoryProvider);
    final page = await repo.fetchNannyMessages();
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;
    ref.read(nannyHasUserMessagedRecentlyProvider.notifier).state =
        page.hasUserMessagedRecently;
    return page.messages;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final repo = ref.read(_nannyMessageRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final page = await repo.fetchNannyMessages();
      _nextCursor = page.nextCursor;
      _hasMore = page.hasMore;
      ref.read(nannyHasUserMessagedRecentlyProvider.notifier).state =
          page.hasUserMessagedRecently;
      return page.messages;
    });
  }

  Future<void> refreshSilently() async {
    final previous = state.value ?? <Message>[];
    final repo = ref.read(_nannyMessageRepositoryProvider);
    final result = await AsyncValue.guard(repo.fetchNannyMessages);
    result.when(
      data: (page) {
        _nextCursor = page.nextCursor;
        _hasMore = page.hasMore;
        ref.read(nannyHasUserMessagedRecentlyProvider.notifier).state =
            page.hasUserMessagedRecently;
        state = AsyncData(page.messages);
      },
      error: (_, __) {
        state = AsyncData(previous);
      },
      loading: () {},
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _nextCursor == null) return;
    _isLoadingMore = true;

    final previous = state.value ?? const <Message>[];
    final repo = ref.read(_nannyMessageRepositoryProvider);
    final result = await AsyncValue.guard(
      () => repo.fetchNannyMessages(cursor: _nextCursor),
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

  Future<bool> sendText(String content) {
    return sendMessage(content: content);
  }

  Future<bool> sendMessage({
    required String content,
    List<String>? imageUrls,
  }) async {
    final trimmed = content.trim();
    final remoteUrls = (imageUrls ?? const <String>[])
        .where((url) => url.startsWith('http'))
        .toList(growable: false);
    if (trimmed.isEmpty && remoteUrls.isEmpty) return false;

    io.Socket? socket = ref.read(socketProvider).valueOrNull;
    socket ??= await ref.read(socketProvider.notifier).reconnect();
    if (socket == null) return false;

    final messagePayload = <String, dynamic>{'content': trimmed};
    if (remoteUrls.isNotEmpty) {
      if (remoteUrls.length == 1) {
        messagePayload['rich_content'] = {
          'type': 'image',
          'url': remoteUrls.first,
        };
      } else {
        messagePayload['rich_content'] = {'type': 'images', 'urls': remoteUrls};
      }
    }

    socket.emit('user.send.nanny', {'message': messagePayload});
    _appendOptimisticSelfMessage(content: trimmed, imageUrls: remoteUrls);

    // Optimistic UI: once user sends a message, hide welcome bubble immediately.
    ref.read(nannyHasUserMessagedRecentlyProvider.notifier).state = true;
    return true;
  }

  Future<bool> setMessagePinned({
    required String messageId,
    required bool isPinned,
  }) async {
    if (messageId.trim().isEmpty) return false;
    final previous = state.value ?? const <Message>[];
    final index = previous.indexWhere((message) => message.id == messageId);

    if (index >= 0) {
      final optimistic = [...previous];
      optimistic[index] = optimistic[index].copyWith(
        pinnedAt: isPinned ? DateTime.now() : null,
        clearPinnedAt: !isPinned,
      );
      state = AsyncData(optimistic);
    }

    final repo = ref.read(_nannyMessageRepositoryProvider);
    try {
      await repo.setMessagePinned(messageId: messageId, isPinned: isPinned);
      ref.invalidate(nannyPinnedMessagesProvider);
      return true;
    } catch (_) {
      if (index >= 0) {
        state = AsyncData(previous);
      }
      return false;
    }
  }

  void _appendOptimisticSelfMessage({
    required String content,
    required List<String> imageUrls,
  }) {
    final current = state.value ?? const <Message>[];
    final optimistic = Message(
      text: content,
      isSentByUser: true,
      imageUrls: imageUrls.isNotEmpty ? imageUrls : null,
    );
    state = AsyncData([...current, optimistic]);
  }

  void appendIncomingPayload(dynamic payload) {
    if (payload is Iterable) {
      for (final item in payload) {
        _appendIncomingItem(item);
      }
      return;
    }
    _appendIncomingItem(payload);
  }

  void _appendIncomingItem(dynamic item) {
    if (item is! Map<String, dynamic>) return;

    try {
      final incoming = Message.fromJson(_normalizeMessagePayload(item));
      _upsertIncoming(incoming);
    } catch (e) {
      debugPrint('⚠️ Failed to parse nanny message payload: $e');
    }
  }

  void _upsertIncoming(Message incoming) {
    if (incoming.isSentByUser) {
      ref.read(nannyHasUserMessagedRecentlyProvider.notifier).state = true;
    }

    final current = state.value ?? const <Message>[];
    final incomingId = incoming.id;

    if (incomingId != null && incomingId.isNotEmpty) {
      final existingIndex = current.indexWhere((m) => m.id == incomingId);
      if (existingIndex >= 0) {
        final updated = [...current];
        updated[existingIndex] = incoming;
        state = AsyncData(updated);
        return;
      }
    }

    if (incoming.isSentByUser) {
      final optimisticIndex = current.indexWhere(
        (message) =>
            message.isSentByUser &&
            (message.id == null || message.id!.isEmpty) &&
            _normalizeText(message.text) == _normalizeText(incoming.text) &&
            _sameImageUrls(message.imageUrls, incoming.imageUrls),
      );
      if (optimisticIndex >= 0) {
        final updated = [...current];
        updated[optimisticIndex] = incoming;
        state = AsyncData(updated);
        return;
      }
    }

    state = AsyncData([...current, incoming]);
  }

  bool get hasMore => _hasMore;
}

final nannySocketBridgeProvider = Provider.autoDispose<void>((ref) {
  io.Socket? attachedSocket;

  void handleNannySendUser(dynamic payload) {
    ref.read(nannyMessagesProvider.notifier).appendIncomingPayload(payload);
    ref.read(nannyTypingProvider.notifier).state = false;
  }

  void handleNannyTyping(dynamic payload) {
    ref.read(nannyTypingProvider.notifier).state = _resolveIsTyping(payload);
  }

  void detach(io.Socket? socket) {
    if (socket == null) return;
    socket.off('nanny.send.user', handleNannySendUser);
    socket.off('nanny.typing', handleNannyTyping);
  }

  void attach(io.Socket socket) {
    if (identical(attachedSocket, socket)) return;
    detach(attachedSocket);
    socket.on('nanny.send.user', handleNannySendUser);
    socket.on('nanny.typing', handleNannyTyping);
    attachedSocket = socket;
  }

  ref.listen<AsyncValue<io.Socket?>>(socketProvider, (previous, next) {
    final prevSocket = previous?.valueOrNull;
    final nextSocket = next.valueOrNull;

    if (!identical(prevSocket, nextSocket)) {
      detach(prevSocket);
    }
    if (nextSocket != null) {
      attach(nextSocket);
    }
  }, fireImmediately: true);

  unawaited(ref.read(socketProvider.notifier).reconnect());

  ref.onDispose(() {
    detach(attachedSocket);
    attachedSocket = null;
  });
});

bool _resolveIsTyping(dynamic payload) {
  if (payload is bool) return payload;
  if (payload is num) return payload != 0;
  if (payload is String) {
    final value = payload.trim().toLowerCase();
    if (value == 'true' ||
        value == '1' ||
        value == 'start' ||
        value == 'typing' ||
        value == 'on') {
      return true;
    }
    return false;
  }
  if (payload is Map<String, dynamic>) {
    final direct =
        payload['is_typing'] ??
        payload['typing'] ??
        payload['isTyping'] ??
        payload['value'];
    if (direct != null) {
      return _resolveIsTyping(direct);
    }

    final status = payload['status'];
    if (status != null) {
      return _resolveIsTyping(status);
    }
  }
  return false;
}

String _normalizeText(String value) => value.trim();

bool _sameImageUrls(List<String>? a, List<String>? b) {
  final left = (a ?? const <String>[]).whereType<String>().toList(
    growable: false,
  );
  final right = (b ?? const <String>[]).whereType<String>().toList(
    growable: false,
  );
  if (left.length != right.length) return false;
  for (var i = 0; i < left.length; i++) {
    if (left[i] != right[i]) return false;
  }
  return true;
}

Map<String, dynamic> _normalizeMessagePayload(Map<String, dynamic> json) {
  final messageMap = _asMap(json['message']);
  if (messageMap != null) {
    return _withOwnershipHints({...json, ...messageMap});
  }

  final dataMap = _asMap(json['data']);
  final nestedMessage = _asMap(dataMap?['message']);
  if (nestedMessage != null) {
    return _withOwnershipHints({...json, ...nestedMessage});
  }

  return _withOwnershipHints(json);
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return null;
}

Map<String, dynamic> _withOwnershipHints(Map<String, dynamic> raw) {
  final sender = _asMap(raw['sender']);
  final role = raw['role'] ?? sender?['type'];
  final senderId = raw['sender_id'] ?? sender?['account_id'] ?? sender?['id'];

  return {
    ...raw,
    if (role != null) 'role': role,
    if (senderId != null) 'sender_id': senderId,
  };
}
