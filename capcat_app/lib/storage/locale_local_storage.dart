import 'package:shared_preferences/shared_preferences.dart';

class LocaleLocalStorage {
  static const _key = 'app_locale_code';

  Future<void> saveLocaleCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }

  Future<String?> readLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
