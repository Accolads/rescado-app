import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/authentication.dart';
import 'package:rescado/src/data/models/token.dart';
import 'package:rescado/src/services/providers/api_client.dart';
import 'package:rescado/src/services/providers/device_data.dart';
import 'package:rescado/src/services/providers/device_storage.dart';
import 'package:rescado/src/utils/logger.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) => ApiAuthenticationRepository(ref.read),
);

// All API endpoints regarding authentication.
abstract class AuthenticationRepository {
  Future<Authentication> register();

  Future<Authentication> login({required String email, required String password});

  Future<Authentication> refresh();

  Future<Authentication> recover();
}

class ApiAuthenticationRepository implements AuthenticationRepository {
  static final _logger = addLogger('ApiAuthenticationRepository');

  final Reader _read;

  ApiAuthenticationRepository(this._read);

  @override
  Future<Authentication> register() async {
    _logger.d('register()');

    final endpoint = Uri.parse('${RescadoConstants.api}/auth/register');
    final deviceName = await _read(deviceDataProvider).getDeviceName();
    final userAgent = await _read(deviceDataProvider).getUserAgent();
    final location = await _read(deviceDataProvider).getLocation();

    final response = await _read(apiClientProvider).postJson(
      endpoint,
      headers: <String, String>{
        RescadoConstants.deviceHeader: deviceName,
        HttpHeaders.userAgentHeader: userAgent,
      },
      body: jsonEncode({
        'latitude': location?.latitude,
        'longitude': location?.longitude,
      }),
    ) as Map<String, dynamic>;

    _read(deviceStorageProvider).saveToken(
      Token.fromJwt(response['jwt'] as String),
    );
    return Authentication.fromJson(response);
  }

  @override
  Future<Authentication> login({required String email, required String password}) async {
    _logger.d('login()');

    final endpoint = Uri.parse('${RescadoConstants.api}/auth/login');
    final deviceName = await _read(deviceDataProvider).getDeviceName();
    final userAgent = await _read(deviceDataProvider).getUserAgent();
    final location = await _read(deviceDataProvider).getLocation();

    final response = await _read(apiClientProvider).postJson(
      endpoint,
      headers: <String, String>{
        RescadoConstants.deviceHeader: deviceName,
        HttpHeaders.userAgentHeader: userAgent,
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'latitude': location?.latitude,
        'longitude': location?.longitude,
      }),
    ) as Map<String, dynamic>;

    _read(deviceStorageProvider).saveToken(
      Token.fromJwt(response['jwt'] as String),
    );
    return Authentication.fromJson(response);
  }

  @override
  Future<Authentication> refresh() async {
    _logger.d('refresh()');

    final endpoint = Uri.parse('${RescadoConstants.api}/auth/refresh');
    final token = await _read(deviceStorageProvider).getToken();
    final deviceName = await _read(deviceDataProvider).getDeviceName();
    final userAgent = await _read(deviceDataProvider).getUserAgent();
    final location = await _read(deviceDataProvider).getLocation();

    final response = await _read(apiClientProvider).postJson(
      endpoint,
      headers: <String, String>{
        RescadoConstants.deviceHeader: deviceName,
        HttpHeaders.userAgentHeader: userAgent,
      },
      body: jsonEncode({
        'uuid': token?.subject,
        'token': token?.refreshToken,
        'latitude': location?.latitude,
        'longitude': location?.longitude,
      }),
    ) as Map<String, dynamic>;

    _read(deviceStorageProvider).saveToken(
      Token.fromJwt(response['jwt'] as String),
    );
    return Authentication.fromJson(response);
  }

  @override
  Future<Authentication> recover() async {
    _logger.d('recover()');

    final endpoint = Uri.parse('${RescadoConstants.api}/auth/recover');
    final token = await _read(deviceStorageProvider).getToken();
    final deviceName = await _read(deviceDataProvider).getDeviceName();
    final userAgent = await _read(deviceDataProvider).getUserAgent();
    final location = await _read(deviceDataProvider).getLocation();

    final response = await _read(apiClientProvider).postJson(
      endpoint,
      headers: <String, String>{
        RescadoConstants.deviceHeader: deviceName,
        HttpHeaders.userAgentHeader: userAgent,
      },
      body: jsonEncode({
        'uuid': token?.subject,
        'latitude': location?.latitude,
        'longitude': location?.longitude,
      }),
    ) as Map<String, dynamic>;

    _read(deviceStorageProvider).saveToken(
      Token.fromJwt(response['jwt'] as String),
    );
    return Authentication.fromJson(response);
  }
}
