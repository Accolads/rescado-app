import 'package:flutter/material.dart';

class RescadoStyle {
  // region Light theme colors

  static Color get lightThemeTextColor => Colors.black;

  static Color get lightThemeTextColorInverted => Colors.white;

  static Color get lightThemeAccentColorLight => const Color(0xFFFBD45C);

  static Color get lightThemeBackgroundColor => Colors.white;

  static Color get lightThemeScaffoldColor => const Color(0xFFFAFAFA);

  // endregion
  // region Dark theme colors

  static Color get darkThemeTextColor => Colors.white;

  static Color get darkThemeTextColorInverted => Colors.black;

  static Color get darkThemeAccentColorLight => const Color(0xFFFBD45C);

  static Color get darkThemeBackgroundColor => Colors.black;

  static Color get darkThemeScaffoldColor => const Color(0xFF050505);

  // endregion

  // Main titles at the top of a view
  static TextStyle viewTitle(BuildContext context) => TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).primaryColor,
      );

  // Big titles used in cards
  static TextStyle cardTitle(BuildContext context, [bool inverted = false]) => TextStyle(
        fontSize: 34.0,
        fontWeight: FontWeight.w900,
        color: inverted ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColor,
      );

  // Very small labels under a card title
  static TextStyle cardSubTitle(BuildContext context, [bool inverted = false]) => TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: inverted ? Theme.of(context).primaryColorDark.withOpacity(0.6) : Theme.of(context).primaryColor.withOpacity(0.6),
      );

  //  Small titles used in cards
  static TextStyle cardSmallTitle(BuildContext context, [bool inverted = false]) => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w800,
        color: inverted ? Theme.of(context).primaryColorDark.withOpacity(0.6) : Theme.of(context).primaryColor.withOpacity(0.6),
      );
}
