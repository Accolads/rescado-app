import 'package:rescado/models/account.dart';

enum UserStatus {
  anonymous, // when connected with token linked to an anonymous account
  identified, // when connected with token linked to an account with user data
  expired, // when attempted to connect with a token that was expired and the session could not be recovered
  blocked, // when attempted to connect with a token linked to a blocked account
}

class User {
  UserStatus status;
  Account? account;
  final String? email;
  final bool? appleLinked;
  final bool? googleLinked;
  final bool? facebookLinked;
  final bool? twitterLinked;
  // TODO Add group related data once that's implemented on the backend

  User({
    required this.status,
    this.account,
    this.email,
    this.appleLinked,
    this.googleLinked,
    this.facebookLinked,
    this.twitterLinked,
  });

  User copyWith({
    UserStatus? status,
    Account? account,
    String? email,
    bool? appleLinked,
    bool? googleLinked,
    bool? facebookLinked,
    bool? twitterLinked,
  }) =>
      User(
        status: status ?? this.status,
        account: account ?? this.account,
        email: email ?? this.email,
        appleLinked: appleLinked ?? this.appleLinked,
        googleLinked: googleLinked ?? this.googleLinked,
        facebookLinked: facebookLinked ?? this.facebookLinked,
        twitterLinked: twitterLinked ?? this.twitterLinked,
      );
}
