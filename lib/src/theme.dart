import 'package:flutter/material.dart';

class RescadoTheme {
  RescadoTheme._();

  static ThemeData get light => ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.orangeAccent,
      ),
      fontFamily: 'M+ Rounded 1c');

  static ThemeData get dark => RescadoTheme.light.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.black54);
}
