import 'package:flutter/foundation.dart';

@immutable
class UserDetail {
  final String id;
  final String phoneNumber;
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final String? address;
  final String? dateOfBirth;
  final String? gender;

  const UserDetail({
    required this.id,
    required this.phoneNumber,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.address,
    this.dateOfBirth,
    this.gender,
  });

  factory UserDetail.fromMap(Map<String, dynamic> map) => UserDetail(
    id: map['id'] as String,
    phoneNumber: map['phone'] as String,
    fullName: map['full_name'] as String?,
    email: map['email'] as String?,
    avatarUrl: map['avatar'] as String?,
    address: map['address'] as String?,
    dateOfBirth: map['dob'] as String?,
    gender: map['gender'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'phone': phoneNumber,
    'full_name': fullName,
    'email': email,
    'avatar': avatarUrl,
    'address': address,
    'dob': dateOfBirth,
    'gender': gender,
  };

  UserDetail copyWith({
    String? id,
    String? phoneNumber,
    String? fullName,
    String? email,
    String? avatarUrl,
    String? address,
    String? dateOfBirth,
    String? gender,
  }) => UserDetail(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    address: address ?? this.address,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
  );
}

enum UserGender { male, female, other }

extension UserGenderExtension on UserGender {
  String get label {
    switch (this) {
      case UserGender.male:
        return 'Nam';
      case UserGender.female:
        return 'Nữ';
      case UserGender.other:
        return 'Khác';
    }
  }

  static UserGender? fromLabel(String? label) {
    switch (label) {
      case 'Nam':
        return UserGender.male;
      case 'Nữ':
        return UserGender.female;
      case 'Khác':
        return UserGender.other;
      default:
        return null;
    }
  }

  String get value {
    switch (this) {
      case UserGender.male:
        return 'MALE';
      case UserGender.female:
        return 'FEMALE';
      case UserGender.other:
        return 'OTHER';
    }
  }

  static UserGender? fromValue(String? value) {
    switch (value) {
      case 'MALE':
        return UserGender.male;
      case 'FEMALE':
        return UserGender.female;
      case 'OTHER':
        return UserGender.other;
      default:
        return null;
    }
  }
}
