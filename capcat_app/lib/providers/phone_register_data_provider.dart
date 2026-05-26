import 'package:flutter_riverpod/flutter_riverpod.dart';

final phoneRegisterDataProvider = StateProvider<PhoneRegisterData>(
  (ref) => PhoneRegisterData(),
);

class PhoneRegisterData {
  final String? name;
  final String? phoneNumber;
  final String? password;

  PhoneRegisterData({this.name, this.phoneNumber, this.password});

  PhoneRegisterData copyWith({
    String? name,
    String? phoneNumber,
    String? password,
  }) {
    return PhoneRegisterData(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }
}
