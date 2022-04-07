import 'package:rescado/src/data/models/image.dart';

enum MembershipStatus {
  invited,
  confirmed,
}

class Membership {
  final String uuid;
  final String name;
  final MembershipStatus status;
  final Image? avatar;

  Membership._({
    required this.uuid,
    required this.name,
    required this.status,
    this.avatar,
  });

  factory Membership.fromJson(Map<String, dynamic> json) => Membership._(
        uuid: json['uuid'] as String,
        name: json['name'] as String,
        status: MembershipStatus.values.byName((json['status'] as String).toLowerCase()),
        avatar: json['avatar'] == null ? null : Image.fromJson(json['avatar'] as Map<String, dynamic>),
      );
}
