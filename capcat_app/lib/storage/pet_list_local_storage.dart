import 'dart:convert';

import 'package:capcat_doca/models/pet_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetListLocalStorage {
  static const _kPetsKey = 'pet_list';
  static const _kFetchedAtKey = 'pet_list_fetched_at';

  Future<void> save(List<PetDetail> pets) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = pets.map((pet) => pet.toCacheJson()).toList();
    await prefs.setString(_kPetsKey, jsonEncode(raw));
    await prefs.setString(_kFetchedAtKey, DateTime.now().toIso8601String());
  }

  Future<List<PetDetail>> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPetsKey);
    if (raw == null) {
      return [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(PetDetail.fromCacheJson)
            .toList();
      }
    } catch (_) {
      await clear();
    }
    return [];
  }

  Future<DateTime?> readFetchedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kFetchedAtKey);
    if (s == null) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPetsKey);
    await prefs.remove(_kFetchedAtKey);
  }
}
