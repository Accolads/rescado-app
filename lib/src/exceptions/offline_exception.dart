class OfflineException implements Exception {
  final String message;

  const OfflineException({this.message = 'The server cannot be reached.'});

  @override
  String toString() => 'OfflineException: $message';
}
