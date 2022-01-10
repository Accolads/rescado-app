import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/data/models/user.dart';

class RescadoMapper {
  RescadoMapper._();

  static UserStatus mapUserStatus(AccountStatus accountStatus) {
    switch (accountStatus) {
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

  static DateTime mapEpoch(int seconds) => DateTime.fromMillisecondsSinceEpoch(
        seconds * 1000,
        isUtc: true,
      );
}
