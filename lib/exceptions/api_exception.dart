class ApiException implements Exception {
  final List<String> messages;

  const ApiException(this.messages);

  @override
  String toString() => 'ApiException: { ${messages.map((message) => '\n • $message')}\n}';
}
