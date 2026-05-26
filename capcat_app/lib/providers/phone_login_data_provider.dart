import 'package:flutter_riverpod/flutter_riverpod.dart';

final phoneLoginDataProvider = StateProvider<PhoneLoginData>(
  (ref) => PhoneLoginData(),
);

class PhoneLoginData {
  final String? phoneNumber;

  PhoneLoginData({this.phoneNumber});

  PhoneLoginData copyWith({String? phoneNumber}) {
    return PhoneLoginData(phoneNumber: phoneNumber ?? this.phoneNumber);
  }
}
