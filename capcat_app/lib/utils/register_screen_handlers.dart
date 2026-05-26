import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'dialog_utils.dart';

class RegisterScreenHandlers {
  static Future<void> handleRegisterPhone(
    BuildContext context,
    String name,
    String phoneNumber,
    String password,
    String otp,
  ) async {
    try {
      final response = await ApiService.phoneRegister(
        name,
        phoneNumber,
        password,
        otp,
      );
      debugPrint(response.toString());
      if (!context.mounted) return;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = e.response?.data['message'] ?? 'Đã xảy ra lỗi';
      throw Exception('Đăng ký thất bại: $msg (status: $status)');
    } catch (_) {
      // DialogUtils.showErrorDialog(
      //   context,
      //   title: 'Lỗi không xác định',
      //   message: '',
      // );
      TO.show(context, 'Đã có lỗi, vui lòng thử lại sau');
    }
  }
}
