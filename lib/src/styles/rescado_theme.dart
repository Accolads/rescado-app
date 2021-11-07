import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rescado/src/styles/rescado_style.dart';

class RescadoTheme {
  RescadoTheme._();

  static ThemeData get light => ThemeData(
        // Font
        fontFamily: 'M+ Rounded 1c',
        // Colors
        primaryColor: RescadoStyle.lightThemeTextColor,
        primaryColorDark: RescadoStyle.lightThemeTextColorInverted,
        backgroundColor: RescadoStyle.lightThemeBackgroundColor,
        scaffoldBackgroundColor: RescadoStyle.lightThemeScaffoldColor,
        colorScheme: const ColorScheme.light().copyWith(
          secondary: RescadoStyle.lightThemeAccentColorLight,
        ),
        // Material
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: RescadoStyle.lightThemeScaffoldColor,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            minimumSize: const Size(60.0, 60.0),
            padding: const EdgeInsets.all(0.0),
            primary: RescadoStyle.lightThemeBackgroundColor,
            shadowColor: RescadoStyle.lightThemeAccentColorLight,
            splashFactory: NoSplash.splashFactory,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: RescadoStyle.lightThemeAccentColorLight,
        ),
      );

  static ThemeData get dark => RescadoTheme.light.copyWith(); // TODO configure proper dark theme
}
