import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/data/models/authentication.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get i10n => AppLocalizations.of(this);
}

extension UserStatusExtension on AccountStatus {
  AuthenticationStatus toAuthenticationStatus() {
    switch (this) {
      case AccountStatus.anonymous:
        return AuthenticationStatus.anonymous;
      case AccountStatus.enrolled:
      case AccountStatus.volunteer:
        return AuthenticationStatus.identified;
      case AccountStatus.blocked:
        return AuthenticationStatus.blocked;
      default:
        throw UnsupportedError('Bad programming. Not all statuses were mapped.');
    }
  }
}

extension DateTimeExtension on int {
  DateTime toEpoch() => DateTime.fromMillisecondsSinceEpoch(
        this * 1000,
        isUtc: true,
      );
}
