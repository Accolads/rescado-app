import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/settings.dart';
import 'package:rescado/src/services/providers/device_storage.dart';
import 'package:rescado/src/utils/logger.dart';

final settingsControllerProvider = StateNotifierProvider<SettingsController, Settings>(
  (ref) => SettingsController(ref.read).._initialize(),
);

// Controller to manage the user's app preferences.
class SettingsController extends StateNotifier<Settings> {
  static final _logger = addLogger('SettingsController');

  final Reader _read;

  SettingsController(this._read) : super(Settings());

  void _initialize() async {
    _logger.d('initialize()');

    final themeMode = await _read(deviceStorageProvider).getThemeMode();
    if (themeMode == ThemeMode.dark || themeMode == ThemeMode.light) {
      state = Settings(
        themeMode: themeMode,
      );
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    _logger.d('setThemeMode()');

    if (themeMode == state.themeMode) {
      // If the change is a lie, do nothing.
      return;
    }
    _read(deviceStorageProvider).saveThemeMode(themeMode);

    state = Settings(
      themeMode: themeMode,
    );
  }
}
