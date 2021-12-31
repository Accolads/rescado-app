import 'package:rescado/models/api_authentication.dart';

class User {
  AuthenticationStatus status;
  String? email;
  String? name;

  User({
    required this.status,
    this.email,
    this.name,
  });

  User copyWith({
    AuthenticationStatus? status,
    String? email,
    String? name,
  }) =>
      User(
        status: status ?? this.status,
        email: email ?? this.email,
        name: name ?? this.name,
      );
}
