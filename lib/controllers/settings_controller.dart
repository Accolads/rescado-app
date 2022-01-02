import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/constants/rescado_storage.dart';
import 'package:rescado/models/settings.dart';
import 'package:rescado/utils/logger.dart';

final settingsControllerProvider = StateNotifierProvider<SettingsController, Settings>(
  (ref) => SettingsController().._initialize(),
);

// Controller to manage the user's app preferences.
class SettingsController extends StateNotifier<Settings> {
  static final _logger = addLogger('SettingsController');

  SettingsController() : super(Settings());

  void _initialize() async {
    _logger.d('initialize()');

    var themeMode = await RescadoStorage.getThemeMode();
    if (themeMode == ThemeMode.dark || themeMode == ThemeMode.light) {
      state = Settings(
        themeMode: themeMode,
      );
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    _logger.d('setThemeMode()');

    if (themeMode == state.themeMode) {
      return;
    }
    RescadoStorage.saveThemeMode(themeMode);

    state = Settings(
      themeMode: themeMode,
    );
  }
}
