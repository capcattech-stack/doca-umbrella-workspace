import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  SocketService._();

  static final SocketService instance = SocketService._();

  static const String defaultUrl = 'https://apidev.capcat.vn/chat-socket';

  io.Socket? _socket;

  io.Socket connect({
    String url = defaultUrl,
    Map<String, dynamic>? query,
    Map<String, dynamic>? auth,
    List<String>? transports,
    String? bearerToken,
  }) {
    if (_socket?.connected == true) {
      return _socket!;
    }

    var builder = io.OptionBuilder().setTransports(
      transports ?? const ['websocket'],
    );
    if (query != null && query.isNotEmpty) {
      builder = builder.setQuery(query);
    }
    if (auth != null && auth.isNotEmpty) {
      builder = builder.setAuth(auth);
    }
    if (bearerToken != null && bearerToken.isNotEmpty) {
      builder = builder.setExtraHeaders(
        {'Authorization': 'Bearer $bearerToken'},
      );
    }
    final options = builder.enableReconnection().build();

    final socket = io.io(url, options);
    socket.connect();
    socket.onConnect((_) => debugPrint('✅ Socket.IO connected to $url'));
    socket.onReconnect((_) => debugPrint('🔁 Socket.IO reconnected'));
    socket.onError((err) => debugPrint('❌ Socket.IO error: $err'));
    socket.onDisconnect(
      (reason) => debugPrint('🔌 Socket.IO disconnected: $reason'),
    );

    _socket = socket;
    return socket;
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }

  io.Socket? get rawSocket => _socket;
}
