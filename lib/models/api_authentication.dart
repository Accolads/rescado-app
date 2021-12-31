enum AuthenticationStatus {
  anonymous,
  enrolled,
  volunteer,
  blocked,
  unknown, // if we get a status from the API we cannot map.
}

class ApiAuthentication {
  final AuthenticationStatus status;

  ApiAuthentication._({
    required this.status,
  });

  factory ApiAuthentication.fromJson(Map<String, dynamic> json) {
    try {
      return ApiAuthentication._(
        status: AuthenticationStatus.values.byName(json['status'] as String),
      );
    } on ArgumentError catch (_) {
      return ApiAuthentication._(
        status: AuthenticationStatus.unknown,
      );
    }
  }
}
