import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_detail.dart';

class UserDetailLocalStorage {
  static const _kUserKey = 'user_detail';
  static const _kFetchedAtKey = 'user_detail_fetched_at';

  Future<void> save(UserDetail user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserKey, jsonEncode(user.toMap()));
    await prefs.setString(_kFetchedAtKey, DateTime.now().toIso8601String());
  }

  Future<UserDetail?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUserKey);
    if (raw == null) return null;
    try {
      return UserDetail.fromMap(jsonDecode(raw) as Map<String, dynamic>);
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
    await prefs.remove(_kUserKey);
    await prefs.remove(_kFetchedAtKey);
  }
}
