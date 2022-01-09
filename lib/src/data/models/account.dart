import 'package:rescado/src/data/models/image.dart';

enum AccountStatus {
  anonymous,
  enrolled,
  volunteer,
  blocked,
}

class Account {
  final int id;
  final AccountStatus status;
  final String uuid;
  final String? name;
  final String? email;
  final bool? appleLinked;
  final bool? googleLinked;
  final bool? facebookLinked;
  final bool? twitterLinked;
  final Image? avatar;

  Account._({
    required this.id,
    required this.status,
    required this.uuid,
    this.name,
    this.email,
    this.appleLinked,
    this.googleLinked,
    this.facebookLinked,
    this.twitterLinked,
    this.avatar,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account._(
        id: json['id'] as int,
        status: AccountStatus.values.byName((json['status'] as String).toLowerCase()),
        uuid: json['uuid'] as String,
        name: json['name'] as String?,
        email: json['email'] as String?,
        appleLinked: json['appleLinked'] as bool?,
        googleLinked: json['googleLinked'] as bool?,
        facebookLinked: json['facebookLinked'] as bool?,
        twitterLinked: json['twitterLinked'] as bool?,
        avatar: json['avatar'] == null ? null : Image.fromJson(json['avatar'] as Map<String, dynamic>),
      );
}
