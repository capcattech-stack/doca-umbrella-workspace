import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/storage/locale_local_storage.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._storage) : super(const Locale('vi')) {
    _load();
  }

  final LocaleLocalStorage _storage;

  Future<void> _load() async {
    final code = await _storage.readLocaleCode();
    if (code != null && code.isNotEmpty) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _storage.saveLocaleCode(locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(LocaleLocalStorage()),
);
