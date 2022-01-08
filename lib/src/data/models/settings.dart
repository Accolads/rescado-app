import 'package:flutter/material.dart';
import 'package:rescado/src/data/custom_theme.dart';

class Settings {
  ThemeMode themeMode; // the theme mode the user prefers
  CustomTheme? lightTheme;
  CustomTheme? darkTheme;

  Settings({
    this.themeMode = ThemeMode.system,
    this.lightTheme,
    this.darkTheme,
  });
}
