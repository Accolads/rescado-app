import 'package:rescado/src/data/models/api_account.dart';
import 'package:rescado/src/data/models/user.dart';

extension UserStatusExtension on ApiAccountStatus{
  UserStatus toUserStatus() {
    switch (this) {
      case ApiAccountStatus.anonymous:
        return UserStatus.anonymous;
      case ApiAccountStatus.enrolled:
      case ApiAccountStatus.volunteer:
        return UserStatus.identified;
      case ApiAccountStatus.blocked:
        return UserStatus.blocked;
      default:
        throw Exception('Bad programming. Not all statuses were mapped.');
    }
  }
}

extension DateTimeExtension on int {
  DateTime toEpoch() => DateTime.fromMillisecondsSinceEpoch(
        this * 1000,
        isUtc: true,
      );
}
