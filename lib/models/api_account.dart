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
  final bool appleLinked;
  final bool googleLinked;
  final bool facebookLinked;
  final bool twitterLinked;
  final ApiImage? avatar;

  ApiAccount._({
    required this.id,
    required this.status,
    required this.uuid,
    this.name,
    this.email,
    required this.appleLinked,
    required this.googleLinked,
    required this.facebookLinked,
    required this.twitterLinked,
    this.avatar,
  });

  factory ApiAccount.fromJson(Map<String, dynamic> json) => ApiAccount._(
        id: json['id'] as int,
        status: ApiAccountStatus.values.byName((json['status'] as String).toLowerCase()),
        uuid: json['uuid'] as String,
        name: json['name'] as String?,
        email: json['email'] as String?,
        appleLinked: json['appleLinked'] as bool? ?? false,
        googleLinked: json['googleLinked'] as bool? ?? false,
        facebookLinked: json['facebookLinked'] as bool? ?? false,
        twitterLinked: json['twitterLinked'] as bool? ?? false,
        avatar: json['avatar'] == null ? null : ApiImage.fromJson(json['avatar'] as Map<String, dynamic>),
      );
}
