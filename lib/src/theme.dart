import 'package:flutter/material.dart';

class RescadoTheme {
  RescadoTheme._();

  static ThemeData get light => ThemeData(fontFamily: 'M+ Rounded 1c');

  static ThemeData get dark => RescadoTheme.light.copyWith();
}
