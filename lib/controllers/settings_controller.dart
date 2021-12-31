import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/constants/rescado_storage.dart';
import 'package:rescado/models/settings.dart';

final settingsControllerProvider = StateNotifierProvider<SettingsController, Settings>(
  (ref) => SettingsController(ref.read).._initialize(),
);

class SettingsController extends StateNotifier<Settings> {
  final Reader _read;

  SettingsController(this._read) : super(Settings());

  void _initialize() async {
    var themeMode = await RescadoStorage.getThemeMode();
    if (themeMode == ThemeMode.dark || themeMode == ThemeMode.light) {
      state = Settings(
        themeMode: themeMode,
      );
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    if (themeMode == state.themeMode) {
      return;
    }
    RescadoStorage.saveThemeMode(themeMode);

    state = Settings(
      themeMode: themeMode,
    );
  }
}
