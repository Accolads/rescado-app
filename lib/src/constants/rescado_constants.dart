import 'package:flutter/material.dart';
import 'package:rescado/src/data/custom_theme.dart';

class RescadoConstants {
  RescadoConstants._();

  // URL for the Rescado API
  static String get api => 'https://rescado.qrivi.dev/api';

  // Timeout before giving up on a HTTP request
  static Duration get timeout => const Duration(seconds: 10);

  // The custom header the server expects to reflect the device's name
  static String get deviceHeader => 'user-device';

  // Maximum angle (in degrees) for the swipeable cards to rotate with
  static double get swipeableCardRotationAngle => 33.0;

  // Minimum horizontal offset for a swipeable card to be dragged before registering as a swipe
  static num get swipeableCardDragOffset => 150;

  // Default light theme when the user has not defined a preference himself yet.
  static CustomThemeIdentifier get defaultLightTheme => CustomThemeIdentifier.light;

  // Default dark theme when the user has not defined a preference himself yet.
  static CustomThemeIdentifier get defaultDarkTheme => CustomThemeIdentifier.dark;

  // region Text styles

  //  Small titles used in cards, buttons or popups that prompt for action
  static TextStyle get actionLabel => const TextStyle(
        fontWeight: FontWeight.w500,
      );

  // endregion

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

  static String get illustrationCuteCatOutside => 'assets/illustrations/cute-cat-outside.svg'; // TODO cleanup if unused

  static String get illustrationWomanHoldingAHeart => 'assets/illustrations/woman-holding-a-heart.svg'; // TODO cleanup if unused

  static String get illustrationWomanOnChairWithPhone => 'assets/illustrations/woman-on-chair-with-phone.svg'; // TODO cleanup if unused

  static String get illustrationWomanWithWrench => 'assets/illustrations/woman-with-wrench.svg';

  // endregion
}
