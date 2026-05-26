import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

enum ConnectivityStatus { connected, disconnected }

final connectivityStatusProvider =
    StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>(
      (ref) => ConnectivityStatusNotifier(),
    );

class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  late final StreamSubscription _connectivitySub;
  bool _disposed = false;

  ConnectivityStatusNotifier() : super(ConnectivityStatus.connected) {
    _init();
  }

  void _init() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((_) {
      _updateConnectionStatus();
    });

    _updateConnectionStatus();
  }

  Future<void> _updateConnectionStatus() async {
    final hasInternet = await InternetConnectionChecker().hasConnection;
    if (_disposed) return;

    final newStatus = hasInternet
        ? ConnectivityStatus.connected
        : ConnectivityStatus.disconnected;

    if (state != newStatus) {
      state = newStatus;
    }
  }

  /// Gọi khi người dùng bấm nút "Thử lại"
  Future<void> retryCheckConnection() async {
    await _updateConnectionStatus();
  }

  @override
  void dispose() {
    _disposed = true;
    _connectivitySub.cancel();
    super.dispose();
  }
}
