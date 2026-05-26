import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_mock_app/models/pet_persona_template_master_data.dart';

class PetPersonaTemplateLocalStorage {
  static const _kDataKey = 'pet_persona_templates';
  static const _kFetchedAtKey = 'pet_persona_templates_fetched_at';

  Future<void> save(List<PetPersonaTemplateMasterData> list) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_kDataKey, encoded);
    await prefs.setString(_kFetchedAtKey, DateTime.now().toIso8601String());
  }

  Future<List<PetPersonaTemplateMasterData>?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kDataKey);
    if (raw == null) return null;
    try {
      final List<dynamic> jsonList = jsonDecode(raw);
      return jsonList
          .map(
            (e) => PetPersonaTemplateMasterData.fromJson(
              e as Map<String, dynamic>,
            ),
          )
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
