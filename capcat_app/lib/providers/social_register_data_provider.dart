import 'package:flutter_riverpod/flutter_riverpod.dart';

final socialRegisterDataProvider = StateProvider<SocialRegisterData>(
  (ref) => SocialRegisterData(),
);

class SocialRegisterData {
  final String? externalId;
  final String? provider;
  final String? firstName;
  final String? lastName;
  final String? avatar;
  final String? email;
  final String? expiresAt;
  final String? phoneNumber;

  SocialRegisterData({
    this.externalId,
    this.provider,
    this.firstName,
    this.lastName,
    this.avatar,
    this.email,
    this.expiresAt,
    this.phoneNumber,
  });

  SocialRegisterData copyWith({
    String? externalId,
    String? provider,
    String? firstName,
    String? lastName,
    String? avatar,
    String? email,
    String? expiresAt,
    String? phoneNumber,
  }) {
    return SocialRegisterData(
      externalId: externalId ?? this.externalId,
      provider: provider ?? this.provider,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      expiresAt: expiresAt ?? this.expiresAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
