class ServerException implements Exception {
  final String message;

  const ServerException({this.message = 'The server seems to be malfunctioning.'});

  @override
  String toString() => 'ServerException: $message';
}
