import 'package:rescado/models/api_image.dart';

enum ApiAccountStatus {
  anonymous,
  enrolled,
  volunteer,
  blocked,
}

class ApiAccount {
  final int id;
  final ApiAccountStatus status;
  final String uuid;
  final String? name;
  final String? email;
  final bool? appleLinked;
  final bool? googleLinked;
  final bool? facebookLinked;
  final bool? twitterLinked;
  final ApiImage? avatar;

  ApiAccount._({
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

  factory ApiAccount.fromJson(Map<String, dynamic> json) => ApiAccount._(
        id: json['id'] as int,
        status: ApiAccountStatus.values.byName((json['status'] as String).toLowerCase()),
        uuid: json['uuid'] as String,
        name: json['name'] as String?,
        email: json['email'] as String?,
        appleLinked: json['appleLinked'] as bool?,
        googleLinked: json['googleLinked'] as bool?,
        facebookLinked: json['facebookLinked'] as bool?,
        twitterLinked: json['twitterLinked'] as bool?,
        avatar: json['avatar'] == null ? null : ApiImage.fromJson(json['avatar'] as Map<String, dynamic>),
      );
}
