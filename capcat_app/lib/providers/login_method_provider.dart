import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';

final loginMethodProvider = FutureProvider<String>(
  (ref) async => AuthService.getLoginMethod(),
);
