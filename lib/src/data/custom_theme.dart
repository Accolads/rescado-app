import 'package:flutter/material.dart';

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
  final Color primaryInvertedColor; // TODO If it is March and this is still not used anywhere, remove this field

  // The primary color but slightly dimmed. Usually to indicate an option that is not selected.
  final Color primaryDimmedColor;

  // The "standard" background color.
  final Color backgroundColor;

  // The "standard" background color, but inverted.
  final Color backgroundInvertedColor; // TODO If it is March and this is still not used anywhere, remove this field

  // A variant on the background color for some subtle contrast. Should be less prominent than the actual background color.
  final Color backgroundVariantColor;

  // A subtle color used for borders, mainly to show a clear separation between bigger containers.
  final Color borderColor;

  // ThemeData for material widgets
  ThemeData get themeData => ThemeData(
        fontFamily: 'M+ Rounded 1c',
        brightness: brightness,
        colorScheme: brightness == Brightness.light ? const ColorScheme.light().copyWith(secondary: accentColor) : const ColorScheme.dark().copyWith(secondary: accentColor),
        primaryColor: primaryColor,
        backgroundColor: backgroundVariantColor,
        scaffoldBackgroundColor: backgroundColor,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: primaryColor,
          labelStyle: const TextStyle(
            fontFamily: 'M+ Rounded 1c',
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelColor: primaryDimmedColor,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: accentColor,
          selectionColor: accentColor.withOpacity(0.4),
        ),
        inputDecorationTheme: InputDecorationTheme(
          suffixIconColor: primaryColor,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: accentColor,
            ),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        }),
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
    required this.borderColor,
  });

  factory CustomTheme.fromId(CustomThemeIdentifier identifier) {
    switch (identifier) {
      case CustomThemeIdentifier.light:
        return CustomTheme.light();
      case CustomThemeIdentifier.dark:
        return CustomTheme.dark();
      default:
        throw UnsupportedError('Bad programming. Not all identifiers were mapped.');
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
        borderColor: const Color(0xFFEEEEEE),
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
        borderColor: const Color(0xFFEEEEEE),
      );
}
