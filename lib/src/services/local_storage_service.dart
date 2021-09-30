import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _themeKey = 'theme';

  LocalStorage._();

  static Future<ThemeMode> getThemeMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? themeMode = sharedPreferences.getString(_themeKey);
    return ThemeMode.values.firstWhere((mode) => mode.toString() == (themeMode ?? ThemeMode.system.toString()));
  }

  static void saveThemeMode(ThemeMode mode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_themeKey, mode.toString());
  }
}
