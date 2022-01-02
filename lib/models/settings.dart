import 'package:flutter/material.dart';

class Settings {
  ThemeMode themeMode; // the theme mode the user prefers

  Settings({
    this.themeMode = ThemeMode.system,
  });
}
