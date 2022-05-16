import 'package:collection/collection.dart';
import 'package:rescado/src/data/models/group.dart';
import 'package:rescado/src/data/models/image.dart';

import 'membership.dart';

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
  final List<Group> groups;

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
    required this.groups,
  });

  Group? get confirmedGroup => groups.where((group) => group.status == MembershipStatus.confirmed).firstOrNull;

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
        groups: (List<Map<String, dynamic>>.from(json['groups'] as List)).map((group) => Group.fromJson(group)).toList(),
      );

  Account copyWith({
    String? name,
    String? email,
    Image? avatar,
  }) =>
      Account._(
        id: id,
        status: status,
        uuid: uuid,
        name: name ?? this.name,
        email: email ?? this.email,
        appleLinked: appleLinked,
        googleLinked: googleLinked,
        facebookLinked: facebookLinked,
        twitterLinked: twitterLinked,
        avatar: avatar ?? this.avatar,
        groups: groups,
      );

  String toJson({String? password, String? appleReference, String? googleReference, String? facebookReference, String? twitterReference}) => '''{
    "name": ${name == null ? 'null' : '"$name"'},
    "email": ${email == null ? 'null' : '"$email"'},
    "password": ${password == null ? 'null' : '"$password"'},
    "avatar": ${avatar?.reference == null ? 'null' : '"${avatar!.reference}"'},
    "appleReference": ${appleReference == null ? 'null' : '"$appleReference"'},
    "googleReference": ${googleReference == null ? 'null' : '"$googleReference"'},
    "facebookReference": ${facebookReference == null ? 'null' : '"$facebookReference"'},
    "twitterReference": ${twitterReference == null ? 'null' : '"$twitterReference"'}
  }''';
}
