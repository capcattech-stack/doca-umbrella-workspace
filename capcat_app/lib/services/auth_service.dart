import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/enums/social_login_platform.dart';
import 'package:flutter_chat_mock_app/providers/social_register_data_provider.dart';
import 'package:flutter_chat_mock_app/services/api_service.dart';
import 'package:flutter_chat_mock_app/services/extension/response_extension.dart';
import 'package:flutter_chat_mock_app/services/model/service_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'access_token';
  static const _defaultLoginMethod = 'phone';

  static Future<void> saveToken(
    String token,
    DateTime expirationTime, {
    String loginMethod = _defaultLoginMethod,
  }) async {
    final data = {
      'token': token,
      'expiration': expirationTime.toIso8601String(),
      'login_method': loginMethod,
    };
    debugPrint('Token: ${data['token']}');
    await _storage.write(key: _tokenKey, value: jsonEncode(data));
  }

  static Future<String?> getToken() async {
    try {
      final value = await _storage.read(key: _tokenKey);
      if (value == null) return null;
      final decoded = jsonDecode(value);
      if (decoded is! Map<String, dynamic>) {
        return value;
      }
      final token = decoded['token'] as String?;
      final expirationString = decoded['expiration'] as String?;
      if (token == null || expirationString == null) {
        return null;
      }
      final expiration = DateTime.parse(expirationString);
      if (DateTime.now().isAfter(expiration)) {
        await clearToken();
        return null;
      }
      return token;
    } catch (e, st) {
      debugPrint('[AuthService] getToken failed: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  static Future<String> getLoginMethod() async {
    try {
      final value = await _storage.read(key: _tokenKey);
      if (value == null) return _defaultLoginMethod;
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) {
        final method = decoded['login_method'] as String?;
        if (method != null && method.isNotEmpty) {
          return method;
        }
      }
    } catch (e, st) {
      debugPrint('[AuthService] getLoginMethod failed: $e');
      debugPrintStack(stackTrace: st);
      return _defaultLoginMethod;
    }
    return _defaultLoginMethod;
  }

  static Future<void> clearToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e, st) {
      debugPrint('[AuthService] clearToken failed: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static Future<void> logoutAll() async {
    await clearToken();

    try {
      await logoutGoogle();
    } catch (_) {}

    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
  }

  static Future<ServiceResponse> registerPhone(
    String name,
    String phoneNumber,
    String password,
    String otp,
  ) async {
    debugPrint('registerPhone: name: $name');
    try {
      final response = await ApiService.phoneRegister(
        name,
        phoneNumber,
        password,
        otp,
      );
      debugPrint('registerPhone:${response.data}');
      if (response.isSuccess) {
        final String token = response.data['access_token'];
        final String expiredTime = response.data['expires_at'];
        await saveToken(
          token,
          DateTime.parse(expiredTime),
          loginMethod: _defaultLoginMethod,
        );
        return ServiceResponse(isSuccess: true);
      }
      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint("Server error: $e");
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<ServiceResponse> loginPhone(
    String phoneNumber,
    String password,
  ) async {
    try {
      final response = await ApiService.phoneLogin(phoneNumber, password);
      debugPrint(response.data.toString());
      if (response.isSuccess) {
        final String token = response.data['access_token'];
        final String expiredTime = response.data['expires_at'];
        await saveToken(
          token,
          DateTime.parse(expiredTime),
          loginMethod: _defaultLoginMethod,
        );
        return ServiceResponse(isSuccess: true);
      }
      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint("Server error: $e");
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<ServiceResponse> handleSocialRegister(
    SocialRegisterData socialRegisterData,
    String otpCode,
  ) async {
    try {
      final response = await ApiService.socialRegister(
        socialRegisterData,
        otpCode,
      );
      debugPrint(response.data.toString());
      if (response.isSuccess) {
        final String token = response.data['access_token'];
        final String expiredTime = response.data['expires_at'];
        final loginMethod =
            socialRegisterData.provider ?? SocialPlatform.google.value;
        await saveToken(
          token,
          DateTime.parse(expiredTime),
          loginMethod: loginMethod,
        );
        return ServiceResponse(isSuccess: true);
      }
      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint("Server error: $e");
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<ServiceResponse> handleSocialLogin(
    String socialPlatform, {
    void Function(String message)? onMessageUpdate,
  }) async {
    OAuthCredential? oAuthCredential;
    if (socialPlatform == SocialPlatform.google.value) {
      onMessageUpdate?.call("Đang kết nối đến Google...");
      oAuthCredential = await loginGoogle();
    }
    if (oAuthCredential == null) {
      return ServiceResponse(isSuccess: false, message: 'Đã hủy đăng nhập');
    }
    onMessageUpdate?.call("Đang xác thực đăng nhập...");
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(oAuthCredential);
    User? user = userCredential.user;
    if (user == null) {
      return ServiceResponse(isSuccess: false, message: 'Đã hủy đăng nhập');
    }

    try {
      // onMessageUpdate?.call("Đang xử lý thông tin...");
      final idTokenResult = await user.getIdTokenResult();
      debugPrint(
        'handleSocialLogin: idTokenResult: ${idTokenResult.toString()}',
      );
      final userId = idTokenResult.claims?["user_id"];
      final expirationTimeInSecs = idTokenResult.claims?["exp"];
      if (userId == null || expirationTimeInSecs == null) {
        return ServiceResponse(
          isSuccess: false,
          message: 'Phiên đăng nhập mất hiệu lực, hãy thử lại sau',
        );
      }
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        expirationTimeInSecs * 1000,
        isUtc: true,
      );
      final expTimeString = dateTime.toIso8601String();

      onMessageUpdate?.call("Đang đồng bộ với máy chủ...");
      final response = await ApiService.socialLogin(
        userId,
        socialPlatform,
        expTimeString,
      );

      if (response.isSuccess) {
        final String token = response.data['access_token'];
        final String expiredTime = response.data['expires_at'];
        await saveToken(
          token,
          DateTime.parse(expiredTime),
          loginMethod: socialPlatform,
        );
        return ServiceResponse(isSuccess: true);
      }

      if (response.statusCode == 404 &&
          (response.data['error'] == 'account_not_found')) {
        final SocialRegisterData socialRegisterData = SocialRegisterData(
          externalId: userId,
          provider: socialPlatform,
          firstName: idTokenResult.claims?['name'] ?? '',
          lastName: '',
          avatar: idTokenResult.claims?['picture'] ?? '',
          email: idTokenResult.claims?['email'] ?? '',
          expiresAt: expTimeString,
        );
        // {
        //   'external_id': userId,
        //   'provider': socialPlatform,
        //   'first_name': idTokenResult.claims?['name'] ?? '',
        //   'last_name': '',
        //   'avatar': idTokenResult.claims?["picture"] ?? "",
        //   'email': idTokenResult.claims?["email"] ?? "",
        //   'expires_at': expTimeString,
        // };
        return ServiceResponse<SocialRegisterData>(
          isSuccess: false,
          message: 'user_not_found',
          data: socialRegisterData,
        );
      }
      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint("Server error: $e");
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<OAuthCredential?> loginGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // User canceled
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential googleOAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return googleOAuthCredential;
  }

  static Future<void> logoutGoogle() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  static Future<ServiceResponse> handleRequestOtp(
    String phone,
    String otpType,
  ) async {
    try {
      final response = await ApiService.requestOtp(phone, otpType);
      debugPrint(response.data.toString());
      if (response.isSuccess) {
        return ServiceResponse(isSuccess: true);
      }
      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint("Server error: $e");
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<ServiceResponse> handleVerifyOtp(
    String phone,
    String otp,
  ) async {
    try {
      final response = await ApiService.verifyOtp(phone, otp);
      debugPrint(response.data.toString());
      if (response.isSuccess) {
        return ServiceResponse(isSuccess: true);
      }
      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint("Server error: $e");
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<ServiceResponse> handleChangeForgotPassword(
    String phone,
    String otp,
    String newPassword,
  ) async {
    try {
      final response = await ApiService.changeForgotPassword(
        phone,
        otp,
        newPassword,
      );
      debugPrint(response.data.toString());
      if (response.isSuccess) {
        return ServiceResponse(isSuccess: true);
      }
      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint("Server error: $e");
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }

  static Future<ServiceResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        return ServiceResponse(isSuccess: false, message: '');
      }
      final response = await ApiService.changePassword(
        token,
        currentPassword,
        newPassword,
      );
      debugPrint('changePassword: ${response.statusCode}');

      if (response.isSuccess) {
        //--In case server sends new token
        // final token = response.data['access_token'];
        // final expiredTime = response.data['expires_at'];
        // if (token != null && expiredTime != null) {
        //   await saveToken(token, DateTime.parse(expiredTime));
        // }

        return ServiceResponse(isSuccess: true);
      }

      return ServiceResponse(
        isSuccess: false,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint('changePassword error: $e');
      return ServiceResponse(
        isSuccess: false,
        message: 'Lỗi kết nối đến máy chủ',
      );
    }
  }
}
