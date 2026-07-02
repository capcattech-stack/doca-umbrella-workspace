import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/services/auth_service.dart';

final loginMethodProvider = FutureProvider<String>(
  (ref) async => AuthService.getLoginMethod(),
);
