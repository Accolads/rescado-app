import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/utils/extensions.dart';

enum AuthenticationStatus {
  anonymous, // when connected with token linked to an anonymous account
  identified, // when connected with token linked to an account with user data
  expired, // when attempted to connect with a token that was expired and the session could not be recovered
  blocked, // when attempted to connect with a token linked to a blocked account
}

class Authentication {
  final AuthenticationStatus status;

  Authentication._({
    required this.status,
  });

  factory Authentication.expired() => Authentication._(status: AuthenticationStatus.expired);

  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication._(
        status: AccountStatus.values.byName((json['status'] as String).toLowerCase()).toAuthenticationStatus(),
      );
}
