import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RescadoStorage {
  RescadoStorage._();

  static const _themeModeKey = 'theme';
  static const _tokenKey = 'token';

  static Future<ThemeMode> getThemeMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? themeMode = sharedPreferences.getString(_themeModeKey);
    return themeMode == null ? ThemeMode.system : ThemeMode.values.byName(themeMode);
  }

  static void saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_themeModeKey, themeMode.name);
  }

  static void deleteThemeMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(_themeModeKey);
  }

  static Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_tokenKey) ?? 'no-token-in-storage';
  }

  static void saveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_tokenKey, token);
  }

  static void deleteToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(_tokenKey);
  }
}
