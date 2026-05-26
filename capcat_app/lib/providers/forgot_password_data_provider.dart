import 'package:flutter_riverpod/flutter_riverpod.dart';

final forgotPasswordDataProvider = StateProvider<ForgotPasswordData>(
  (ref) => ForgotPasswordData(),
);

class ForgotPasswordData {
  final String? phoneNumber;
  final String? otp;
  final String? newPassword;

  ForgotPasswordData({this.phoneNumber, this.otp, this.newPassword});

  ForgotPasswordData copyWith({
    String? phoneNumber,
    String? otp,
    String? newPassword,
  }) {
    return ForgotPasswordData(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
    );
  }
}
