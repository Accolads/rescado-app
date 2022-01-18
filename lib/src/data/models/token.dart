import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/utils/extensions.dart';

class Token {
  final String jwt;
  final String issuer;
  final String audience;
  final String subject; // aka account uuid
  final AccountStatus status;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final DateTime notValidBefore;
  final String deviceName;
  final String userAgent;
  final String ipAddress;
  final String refreshToken;
  final DateTime refreshExpiry;

  String get headerValue => 'Bearer $jwt';

  Token._({
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

  factory Token.fromJwt(String jwt) {
    final payload = JwtDecoder.decode(jwt);

    return Token._(
      jwt: jwt,
      issuer: payload['iss'] as String,
      audience: payload['aud'] as String,
      subject: payload['sub'] as String,
      status: AccountStatus.values.byName((payload['status'] as String).toLowerCase()),
      issuedAt: (payload['iat'] as int).toEpoch(),
      expiresAt: (payload['exp'] as int).toEpoch(),
      notValidBefore: (payload['nbf'] as int).toEpoch(),
      deviceName: payload['device'] as String,
      userAgent: payload['agent'] as String,
      ipAddress: payload['ipAddress'] as String,
      refreshToken: payload['refreshToken'] as String,
      refreshExpiry: (payload['refreshExpiry'] as int).toEpoch(),
    );
  }
}
