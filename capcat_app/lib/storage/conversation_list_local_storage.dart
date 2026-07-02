import 'dart:convert';

import 'package:capcat_doca/models/conversation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationListLocalStorage {
  static const _kConversationsKey = 'conversation_list';
  static const _kFetchedAtKey = 'conversation_list_fetched_at';

  Future<void> save(List<Conversation> conversations) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = conversations.map((c) => c.toCacheJson()).toList();
    await prefs.setString(_kConversationsKey, jsonEncode(raw));
    await prefs.setString(_kFetchedAtKey, DateTime.now().toIso8601String());
  }

  Future<List<Conversation>> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kConversationsKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(Conversation.fromCacheJson)
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
    await prefs.remove(_kConversationsKey);
    await prefs.remove(_kFetchedAtKey);
  }
}
