enum UserStatus {
  newbie, // there was no JWT found in storage
  anonymous, // when connected with token linked to an anonymous account
  identified, // when connected with token linked to an account with user data
  expired, // when attempted to connect with a token that was expired and the session could not be recovered
  blocked, // when attempted to connect with a token linked to a blocked account
}

class User {
  UserStatus status;
  String? email;
  String? name;

  User({
    required this.status,
    this.email,
    this.name,
  });

  User copyWith({
    UserStatus? status,
    String? email,
    String? name,
  }) =>
      User(
        status: status ?? this.status,
        email: email ?? this.email,
        name: name ?? this.name,
      );
}
