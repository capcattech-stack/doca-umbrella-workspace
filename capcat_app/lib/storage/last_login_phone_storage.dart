import 'package:shared_preferences/shared_preferences.dart';

class LastLoginPhoneStorage {
  static const _kLastPhoneKey = 'last_login_phone_number';

  Future<void> save(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastPhoneKey, phoneNumber);
  }

  Future<String?> read() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLastPhoneKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLastPhoneKey);
  }
}
