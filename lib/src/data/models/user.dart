import 'package:rescado/src/data/models/account.dart';

enum UserStatus {
  anonymous, // when connected with token linked to an anonymous account
  identified, // when connected with token linked to an account with user data
  expired, // when attempted to connect with a token that was expired and the session could not be recovered
  blocked, // when attempted to connect with a token linked to a blocked account
}

class User {
  UserStatus status;
  Account? account;

  // TODO Add group related data once that's implemented on the backend

  User({
    required this.status,
    this.account,
  });

  User copyWith({
    UserStatus? status,
    Account? account,
  }) =>
      User(
        status: status ?? this.status,
        account: account ?? this.account,
      );
}
