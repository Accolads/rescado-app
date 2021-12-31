class RescadoConstants {
  RescadoConstants._();

  // URL for the Rescado API
  static String get api => 'https://rescado.qrivi.dev/api';

  // Timeout before giving up on a HTTP request
  static Duration get timeout => const Duration(seconds: 10);
}
