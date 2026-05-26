import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final socketProvider =
    AutoDisposeAsyncNotifierProvider<SocketNotifier, io.Socket?>(
  SocketNotifier.new,
);

class SocketNotifier extends AutoDisposeAsyncNotifier<io.Socket?> {
  @override
  Future<io.Socket?> build() async {
    final socket = await _connect();
    ref.onDispose(SocketService.instance.dispose);
    return socket;
  }

  io.Socket? get socket => state.valueOrNull;

  Future<io.Socket?> reconnect() async {
    final socket = await _connect();
    state = AsyncData(socket);
    return socket;
  }

  void emit(String event, dynamic data) {
    socket?.emit(event, data);
  }

  void disconnect() {
    SocketService.instance.dispose();
    state = const AsyncData(null);
  }

  Future<io.Socket?> _connect() async {
    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) return null;
    return SocketService.instance.connect(bearerToken: token);
  }
}
