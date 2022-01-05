import 'package:rescado/models/api_account.dart';
import 'package:rescado/models/user.dart';

class RescadoMapper{
  RescadoMapper._();

  static UserStatus mapUserStatus(ApiAccountStatus apiAccountStatus){
    switch( apiAccountStatus){
      case ApiAccountStatus.anonymous:
        return UserStatus.anonymous;
      case ApiAccountStatus.enrolled:
      case ApiAccountStatus.volunteer:
        return UserStatus.identified;
      case ApiAccountStatus.blocked:
        return UserStatus.blocked;
      default:
        throw Exception('Bad programming. Not all statusses were mapped.');
    }
  }
}
