import 'package:dio/dio.dart';

extension ResponseExtension on Response {
  bool get isSuccess {
    final code = statusCode ?? 0;
    return code >= 200 && code < 300;
  }
}
