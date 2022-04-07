import 'package:rescado/src/data/models/membership.dart';

class Group {
  final int id;
  final MembershipStatus status;
  final List<Membership> members;

  Iterable<Membership> get confirmedMembers => members.where((member) => member.status == MembershipStatus.confirmed);

  Group._({
    required this.id,
    required this.status,
    required this.members,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group._(
        id: json['id'] as int,
        status: MembershipStatus.values.byName((json['status'] as String).toLowerCase()),
        members: (List<Map<String, dynamic>>.from(json['members'] as List)).map((member) => Membership.fromJson(member)).toList(),
      );
}
