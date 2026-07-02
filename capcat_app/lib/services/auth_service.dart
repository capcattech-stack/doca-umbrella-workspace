import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capcat_doca/enums/social_login_platform.dart';
import 'package:capcat_doca/models/user_detail.dart';
import 'package:capcat_doca/providers/social_register_data_provider.dart';
import 'package:capcat_doca/services/api_service.dart';
import 'package:capcat_doca/services/extension/response_extension.dart';
import 'package:capcat_doca/services/model/service_response.dart';
import 'package:capcat_doca/storage/user_detail_local_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'access_token';
  static const _defaultLoginMethod = 'phone';
  static const Set<String> _socialLoginMethods = {
    'google',
    'facebook',
    'apple',
  };

  static Future<void> saveSession(
    String token,
    DateTime expirationTime, {
    String loginMethod = _defaultLoginMethod,
    UserDetail? profileFallback,
  }) async {
    final data = {
      'token': token,
      'expiration': expirationTime.toIso8601String(),
      'login_method': loginMethod,
    };
    debugPrint('Token: ${data['token']}');
    await _storage.write(key: _tokenKey, value: jsonEncode(data));
    await _cacheUserProfile(token, fallback: profileFallback);
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

  static Future<bool> hasValidBootstrapSession() async {
    final token = await getToken();
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (token == null) {
      if (firebaseUser != null) {
        debugPrint(
          '[AuthService] Bootstrap mismatch: Firebase user exists but token is missing. Cleaning Firebase session.',
        );
        await _safeClearFirebaseSession();
      }
      return false;
    }

    final loginMethod = await getLoginMethod();
    final requiresFirebaseSession = _socialLoginMethods.contains(loginMethod);

    if (requiresFirebaseSession) {
      if (firebaseUser == null) {
        debugPrint(
          '[AuthService] Bootstrap mismatch: social token exists but Firebase session is missing. Logging out all.',
        );
        await logoutAll();
        return false;
      }
      return true;
    }

    if (firebaseUser != null) {
      debugPrint(
        '[AuthService] Bootstrap cleanup: non-social session found with stale Firebase user. Clearing Firebase session only.',
      );
      await _safeClearFirebaseSession();
    }

    return true;
  }

  static Future<void> _safeClearFirebaseSession() async {
    try {
      await logoutGoogle();
    } catch (e, st) {
      debugPrint('[AuthService] logoutGoogle failed during cleanup: $e');
      debugPrintStack(stackTrace: st);
    }

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e, st) {
      debugPrint('[AuthService] Firebase signOut failed during cleanup: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static Future<void> _cacheUserProfile(
    String token, {
    UserDetail? fallback,
  }) async {
    try {
      final response = await ApiService.getMyProfile(token);
      debugPrint(
        '[AuthService] getMyProfile during session save: ${response.statusCode} ${response.data}',
      );
      if (response.isSuccess) {
        final raw = response.data is Map<String, dynamic>
            ? response.data['data']
            : null;
        if (raw is Map<String, dynamic>) {
          await UserDetailLocalStorage().save(_userDetailFromMap(raw));
          return;
        }
      }
    } catch (e, st) {
      debugPrint('[AuthService] Failed to hydrate profile from API: $e');
      debugPrintStack(stackTrace: st);
    }

    if (fallback != null) {
      try {
        await UserDetailLocalStorage().save(fallback);
      } catch (e, st) {
        debugPrint('[AuthService] Failed to save fallback profile: $e');
        debugPrintStack(stackTrace: st);
      }
    }
  }

  static UserDetail _userDetailFromMap(Map<String, dynamic> map) {
    return UserDetail(
      id: (map['id'] ?? '').toString(),
      phoneNumber: (map['phone'] ?? '').toString(),
      fullName: map['full_name'] as String?,
      email: map['email'] as String?,
      avatarUrl: map['avatar'] as String?,
      address: map['address'] as String?,
      dateOfBirth: map['dob'] as String?,
      gender: map['gender'] as String?,
    );
  }

  static UserDetail _buildSocialFallbackProfile(
    SocialRegisterData socialRegisterData,
  ) {
    final firstName = (socialRegisterData.firstName ?? '').trim();
    final lastName = (socialRegisterData.lastName ?? '').trim();
    final fullName = [
      firstName,
      lastName,
    ].where((e) => e.isNotEmpty).join(' ').trim();

    return UserDetail(
      id: socialRegisterData.externalId ?? '',
      phoneNumber: socialRegisterData.phoneNumber ?? '',
      fullName: fullName.isEmpty ? null : fullName,
      email: socialRegisterData.email,
      avatarUrl: socialRegisterData.avatar,
    );
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
        await saveSession(
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
        await saveSession(
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
        await saveSession(
          token,
          DateTime.parse(expiredTime),
          loginMethod: loginMethod,
          profileFallback: _buildSocialFallbackProfile(socialRegisterData),
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
        final fallbackProfile = UserDetail(
          id: userId.toString(),
          phoneNumber: '',
          fullName: user.displayName?.trim().isNotEmpty == true
              ? user.displayName!.trim()
              : null,
          email: user.email,
          avatarUrl: user.photoURL,
        );
        await saveSession(
          token,
          DateTime.parse(expiredTime),
          loginMethod: socialPlatform,
          profileFallback: fallbackProfile,
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
