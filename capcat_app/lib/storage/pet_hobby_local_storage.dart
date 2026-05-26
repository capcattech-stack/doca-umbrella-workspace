import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_mock_app/models/pet_hobby_master_data.dart';

class PetHobbyLocalStorage {
  static const _kDataKey = 'pet_hobbies';
  static const _kFetchedAtKey = 'pet_hobbies_fetched_at';

  Future<void> save(List<PetHobbyMasterData> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_kDataKey, encoded);
    await prefs.setString(_kFetchedAtKey, DateTime.now().toIso8601String());
  }

  Future<List<PetHobbyMasterData>?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kDataKey);
    if (raw == null) return null;
    try {
      final List<dynamic> jsonList = jsonDecode(raw);
      return jsonList
          .map((e) => PetHobbyMasterData.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      await clear();
      return null;
    }
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
    await prefs.remove(_kDataKey);
    await prefs.remove(_kFetchedAtKey);
  }
}
