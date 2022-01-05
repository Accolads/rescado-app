class KnownException implements Exception {
  final String message;

  const KnownException({required this.message});

  @override
  String toString() => 'KnownException: $message';
}
