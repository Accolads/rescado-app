import 'package:rescado/src/data/models/account.dart';

class Authentication {
  final AccountStatus status;

  Authentication._({
    required this.status,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication._(
        status: AccountStatus.values.byName((json['status'] as String).toLowerCase()),
      );
}
