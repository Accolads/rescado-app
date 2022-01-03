import 'package:flutter/material.dart';

class RescadoStyle {
  RescadoStyle._();

  // region Text styles

  // Main titles at the top of a view
  static TextStyle viewTitle(BuildContext context) => TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).primaryColor,
      );

  // Big titles used in cards
  static TextStyle swipeableCardTitle(BuildContext context, [bool inverted = false]) => TextStyle(
        fontSize: 34.0,
        fontWeight: FontWeight.w900,
        color: inverted ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColor,
      );

  // Very small labels under a card title
  static TextStyle swipeableCardSubTitle(BuildContext context, [bool inverted = false]) => TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: inverted ? Theme.of(context).primaryColorDark.withOpacity(0.6) : Theme.of(context).primaryColor.withOpacity(0.6),
      );

  //  Small titles used in cards
  static TextStyle swipeableCardSmallTitle(BuildContext context, [bool inverted = false]) => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w800,
        color: inverted ? Theme.of(context).primaryColorDark.withOpacity(0.6) : Theme.of(context).primaryColor.withOpacity(0.6),
      );

  //  Small titles used in cards, buttons or popups that prompt for action
  static TextStyle actionLabel(BuildContext context) => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).primaryColor,
  );

  //  Small text used in cards, buttons or popups that prompt for action
  static TextStyle actionBody(BuildContext context) => TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).primaryColor,
  );

  //endregion

  // region Icon assets

  static String get iconArrowUp => 'assets/icons/arrow-up.svg';

  static String get iconChevronLeft => 'assets/icons/chevron-left.svg';

  static String get iconCompass => 'assets/icons/compass.svg';

  static String get iconCross => 'assets/icons/cross.svg';

  static String get iconEnvelope => 'assets/icons/envelope.svg';

  static String get iconHeartBroken => 'assets/icons/heart-broken.svg';

  static String get iconHeartFilled => 'assets/icons/heart-filled.svg';

  static String get iconHeartOutline => 'assets/icons/heart-outline.svg';

  static String get iconInfo => 'assets/icons/info.svg';

  static String get iconKey => 'assets/icons/key.svg';

  static String get iconLogo => 'assets/icons/logo.svg';

  static String get iconRefresh => 'assets/icons/refresh.svg';

  static String get iconShareAndroid => 'assets/icons/share-android.svg';

  static String get iconShareiOS => 'assets/icons/share-ios.svg';

  static String get iconUser => 'assets/icons/user.svg';

  static String get iconUserPlus => 'assets/icons/user-plus.svg';

  static String get iconUsers => 'assets/icons/users.svg';

  // endregion

  // region Illustration assets

  static String get illustrationWomanWithWrench => 'assets/illustrations/woman-with-wrench.svg';

  //endregion

  // region Light theme colors

  static Color get lightThemeTextColor => Colors.black;

  static Color get lightThemeTextColorInverted => Colors.white;

  static Color get lightThemeAccentColorDark => const Color(0xFFFBD45C);

  static Color get lightThemeAccentColorLight => const Color(0xFFFBF4E0);

  static Color get lightThemeBackgroundColor => Colors.white;

  static Color get lightThemeScaffoldColor => const Color(0xFFFAFAFA);

  static Color get lightThemeIconColor => const Color(0xFF888888);

  static Color get lightThemeActiveIconColor => Colors.black;

  // endregion
  // region Dark theme colors

  static Color get darkThemeTextColor => Colors.white;

  static Color get darkThemeTextColorInverted => Colors.black;

  static Color get darkThemeAccentColorDark => const Color(0xFFFBD45C);

  static Color get darkThemeAccentColorLight => const Color(0xFFFBF4E0);

  static Color get darkThemeBackgroundColor => Colors.black;

  static Color get darkThemeScaffoldColor => const Color(0xFF050505);

  static Color get darkThemeIconColor => const Color(0xFF888888);

  static Color get darkThemeActiveIconColor => Colors.white;

// endregion
}
