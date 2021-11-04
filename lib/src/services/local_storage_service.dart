import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _themeKey = 'theme';
  static const _tokenKey = 'token';

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

  static Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_tokenKey);
    if (token == null) throw ArgumentError.notNull('token');
    return token;
  }

  static void saveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_tokenKey, token);
  }

  static void removeToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(_tokenKey);
  }
}
