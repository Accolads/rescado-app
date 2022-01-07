import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/api_authentication.dart';
import 'package:rescado/src/data/models/api_token.dart';
import 'package:rescado/src/services/providers/api_client.dart';
import 'package:rescado/src/services/providers/device_data.dart';
import 'package:rescado/src/services/providers/device_storage.dart';
import 'package:rescado/src/utils/logger.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) => ApiAuthenticationRepository(ref.read),
);

// All API endpoints regarding authentication.
abstract class AuthenticationRepository {
  Future<ApiAuthentication> register();

  Future<ApiAuthentication> login({required String email, required String password});

  Future<ApiAuthentication> refresh();

  Future<ApiAuthentication> recover();
}

class ApiAuthenticationRepository implements AuthenticationRepository {
  static final _logger = addLogger('ApiAuthenticationRepository');

  final Reader _read;

  ApiAuthenticationRepository(this._read);

  @override
  Future<ApiAuthentication> register() async {
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
    );

    _read(deviceStorageProvider).saveApiToken(
      ApiToken.fromJwt(response['jwt'] as String),
    );
    return ApiAuthentication.fromJson(response);
  }

  @override
  Future<ApiAuthentication> login({required String email, required String password}) async {
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
    );

    _read(deviceStorageProvider).saveApiToken(
      ApiToken.fromJwt(response['jwt'] as String),
    );
    return ApiAuthentication.fromJson(response);
  }

  @override
  Future<ApiAuthentication> refresh() async {
    _logger.d('refresh()');

    final endpoint = Uri.parse('${RescadoConstants.api}/auth/refresh');
    final token = await _read(deviceStorageProvider).getApiToken();
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
    );

    _read(deviceStorageProvider).saveApiToken(
      ApiToken.fromJwt(response['jwt'] as String),
    );
    return ApiAuthentication.fromJson(response);
  }

  @override
  Future<ApiAuthentication> recover() async {
    _logger.d('recover()');

    final endpoint = Uri.parse('${RescadoConstants.api}/auth/recover');
    final token = await _read(deviceStorageProvider).getApiToken();
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
    );

    _read(deviceStorageProvider).saveApiToken(
      ApiToken.fromJwt(response['jwt'] as String),
    );
    return ApiAuthentication.fromJson(response);
  }
}
