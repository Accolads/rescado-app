import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum CustomThemeIdentifier {
  light,
  dark,
}

class CustomTheme {
  final CustomThemeIdentifier identifier;

  // General indication whether the theme is a "light" or "dark" theme.
  final Brightness brightness;

  // The bright accent color
  final Color accentColor;

  // The accent color but more dimmed, to be used as e.g. container background color.
  final Color accentDimmedColor;

  // Colors for "standard text". Color opposite to the "standard background".
  final Color primaryColor;

  // The opposite from the colors above. To display on containers that already flip the colors around.
  final Color primaryInvertedColor;

  // The primary color but slightly dimmed. Usually to indicate an option that is not selected.
  final Color primaryDimmedColor;

  // The "standard" background color.
  final Color backgroundColor;

  // The "standard" background color, but inverted.
  final Color backgroundInvertedColor;

  // A variant on the background color for some subtle contrast. Should be less prominent than the actual background color.
  final Color backgroundVariantColor;

  // ThemeData for material widgets TODO remove properties that have no impact (aka that were just set so we could read them in custom widgets)
  ThemeData get themeData => ThemeData(
        fontFamily: 'M+ Rounded 1c',
        brightness: brightness,
        colorScheme: brightness == Brightness.light ? const ColorScheme.light().copyWith(secondary: accentColor) : const ColorScheme.dark().copyWith(secondary: accentColor),
        primaryColor: primaryColor,
        backgroundColor: backgroundVariantColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: primaryColor,
          unselectedLabelColor: primaryDimmedColor,
        ),
      );

  CustomTheme._({
    required this.identifier,
    required this.brightness,
    required this.accentColor,
    required this.accentDimmedColor,
    required this.primaryColor,
    required this.primaryInvertedColor,
    required this.primaryDimmedColor,
    required this.backgroundColor,
    required this.backgroundInvertedColor,
    required this.backgroundVariantColor,
  });

  factory CustomTheme.fromId(CustomThemeIdentifier identifier) {
    switch (identifier) {
      case CustomThemeIdentifier.light:
        return CustomTheme.light();
      case CustomThemeIdentifier.dark:
        return CustomTheme.dark();
    }
  }

  factory CustomTheme.light() => CustomTheme._(
        identifier: CustomThemeIdentifier.light,
        brightness: Brightness.light,
        accentColor: const Color(0xFFFBD45C),
        accentDimmedColor: const Color(0xFFFBF4E0),
        primaryColor: Colors.black,
        primaryInvertedColor: Colors.white,
        primaryDimmedColor: const Color(0xFF888888),
        backgroundColor: const Color(0xFFFAFAFA),
        backgroundInvertedColor: Colors.black,
        backgroundVariantColor: Colors.white,
      );

  factory CustomTheme.dark() => CustomTheme._(
        identifier: CustomThemeIdentifier.dark,
        brightness: Brightness.dark,
        accentColor: const Color(0xFFFBD45C),
        accentDimmedColor: const Color(0xFFFBF4E0),
        primaryColor: Colors.white,
        primaryInvertedColor: Colors.black,
        primaryDimmedColor: const Color(0xFF888888),
        backgroundColor: Colors.black,
        backgroundInvertedColor: Colors.white,
        backgroundVariantColor: const Color(0xFF050505),
      );
}
