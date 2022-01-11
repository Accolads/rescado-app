import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/data/models/user.dart';

extension UserStatusExtension on AccountStatus {
  UserStatus toUserStatus() {
    switch (this) {
      case AccountStatus.anonymous:
        return UserStatus.anonymous;
      case AccountStatus.enrolled:
      case AccountStatus.volunteer:
        return UserStatus.identified;
      case AccountStatus.blocked:
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
