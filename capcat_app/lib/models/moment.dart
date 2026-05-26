import 'package:flutter/material.dart';

class Moment {
  final String id;
  final String? accountId;
  final String caption;
  final DateTime createdAt;
  final List<MomentMedia> media;
  final List<MomentPet> pets;

  Moment({
    required this.id,
    required this.caption,
    required this.createdAt,
    this.accountId,
    this.media = const [],
    this.pets = const [],
  });

  factory Moment.fromJson(Map<String, dynamic> json) {
    debugPrint('[Moment.fromJson] moment_pets: ${json['moment_pets']}');
    return Moment(
      id: json['id'] as String,
      accountId: json['account_id'] as String?,
      caption: (json['caption'] as String?)?.trim() ?? '',
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      media:
          (json['media'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(MomentMedia.fromJson)
              .toList() ??
          const [],
      pets:
          (json['moment_pets'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(MomentPet.fromJson)
              .toList() ??
          const [],
    );
  }
}

class MomentMedia {
  final String id;
  final String momentId;
  final String url;

  MomentMedia({required this.id, required this.momentId, required this.url});

  factory MomentMedia.fromJson(Map<String, dynamic> json) => MomentMedia(
    id: (json['id'] ?? '').toString(),
    momentId: (json['moment_id'] ?? '').toString(),
    url: (json['url'] as String?)?.trim() ?? '',
  );
}

class MomentPet {
  final String id;
  final String name;
  final String? avatar;

  MomentPet({required this.id, required this.name, this.avatar});

  factory MomentPet.fromJson(Map<String, dynamic> json) {
    final pet = json['pet'] as Map<String, dynamic>? ?? {};
    return MomentPet(
      id: (pet['id'] ?? json['pet_id'] ?? json['id'] ?? '').toString(),
      name:
          (pet['name'] as String?)?.trim() ??
          (json['name'] as String?)?.trim() ??
          '',
      avatar:
          (pet['avatar'] as String?)?.trim() ??
          (json['avatar'] as String?)?.trim(),
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toLocal();
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value)?.toLocal();
  }
  return null;
}
