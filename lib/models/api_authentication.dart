import 'package:rescado/models/api_account.dart';

class ApiAuthentication {
  final ApiAccountStatus status;

  ApiAuthentication._({
    required this.status,
  });

  factory ApiAuthentication.fromJson(Map<String, dynamic> json) => ApiAuthentication._(
        status: ApiAccountStatus.values.byName((json['status'] as String).toLowerCase()),
      );
}
