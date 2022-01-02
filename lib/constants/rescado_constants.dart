class RescadoConstants {
  RescadoConstants._();

  // URL for the Rescado API
  static String get api => 'https://rescado.qrivi.dev/api';

  // Timeout before giving up on a HTTP request
  static Duration get timeout => const Duration(seconds: 10);

  // Maximum angle (in degrees) for the swipeable cards to rotate with
  static double get swipeableCardRotationAngle => 45.0;

  // Minimum horizontal offset for a swipeable card to be dragged before registering as a swipe
  static num get swipeableCardDragOffset => 150;
}
