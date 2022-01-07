import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rescado/src/data/models/api_account.dart';
import 'package:rescado/src/utils/mapper.dart';

class ApiToken {
  final String jwt;
  final String issuer;
  final String audience;
  final String subject; // aka account uuid
  final ApiAccountStatus status;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final DateTime notValidBefore;
  final String deviceName;
  final String userAgent;
  final String ipAddress;
  final String refreshToken;
  final DateTime refreshExpiry;

  String get headerValue => 'Bearer $jwt';

  ApiToken._({
    required this.jwt,
    required this.issuer,
    required this.audience,
    required this.subject,
    required this.status,
    required this.issuedAt,
    required this.expiresAt,
    required this.notValidBefore,
    required this.deviceName,
    required this.userAgent,
    required this.ipAddress,
    required this.refreshToken,
    required this.refreshExpiry,
  });

  factory ApiToken.fromJwt(String jwt) {
    final payload = JwtDecoder.decode(jwt);

    return ApiToken._(
      jwt: jwt,
      issuer: payload['iss'] as String,
      audience: payload['aud'] as String,
      subject: payload['sub'] as String,
      status: ApiAccountStatus.values.byName((payload['status'] as String).toLowerCase()),
      issuedAt: RescadoMapper.mapEpoch(payload['iat'] as int),
      expiresAt: RescadoMapper.mapEpoch(payload['exp'] as int),
      notValidBefore: RescadoMapper.mapEpoch(payload['nbf'] as int),
      deviceName: payload['device'] as String,
      userAgent: payload['agent'] as String,
      ipAddress: payload['ipAddress'] as String,
      refreshToken: payload['refreshToken'] as String,
      refreshExpiry: RescadoMapper.mapEpoch(payload['refreshExpiry'] as int),
    );
  }
}
