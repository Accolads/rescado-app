import 'package:flutter/material.dart';
import 'package:rescado/src/services/local_storage_service.dart';

class SettingsService {
  Future<ThemeMode> themeMode() async => LocalStorage.getThemeMode();

  Future<void> updateThemeMode(ThemeMode mode) async => LocalStorage.saveThemeMode(mode);
}
