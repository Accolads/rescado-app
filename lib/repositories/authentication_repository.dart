import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rescado/constants/rescado_constants.dart';
import 'package:rescado/constants/rescado_storage.dart';
import 'package:rescado/models/api_authentication.dart';
import 'package:rescado/providers/api_client.dart';
import 'package:rescado/providers/device_data.dart';
import 'package:rescado/utils/logger.dart';

final authenticationRepositoryProvider = Provider<AuthenticationRepository>((ref) => ApiAuthenticationRepository(ref.read));

// All API endpoints regarding authentication.
abstract class AuthenticationRepository {
  Future<ApiAuthentication> register();

  Future<ApiAuthentication> login(String email, String password);

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

    var endpoint = Uri.parse('${RescadoConstants.api}/auth/register');
    var userAgent = await _read(deviceDataProvider).getUserAgent();
    var location = await _read(deviceDataProvider).getLocation();

    final response = await _read(httpClientProvider).postJson(
      endpoint,
      headers: <String, String>{
        HttpHeaders.userAgentHeader: userAgent,
      },
      body: location == null
          ? null
          : jsonEncode({
              'latitude': location.latitude,
              'longitude': location.longitude,
            }),
    );

    RescadoStorage.saveToken(response['token'] as String);
    return ApiAuthentication.fromJson(response);
  }

  @override
  Future<ApiAuthentication> login(String email, String password) async {
    _logger.d('login()');

    var endpoint = Uri.parse('${RescadoConstants.api}/auth/login');
    var userAgent = await _read(deviceDataProvider).getUserAgent();
    var location = await _read(deviceDataProvider).getLocation();

    final response = await _read(httpClientProvider).postJson(
      endpoint,
      headers: <String, String>{
        HttpHeaders.userAgentHeader: userAgent,
      },
      body: location == null
          ? null
          : jsonEncode({
              'email': email,
              'password': password,
              'latitude': location.latitude,
              'longitude': location.longitude,
            }),
    );

    RescadoStorage.saveToken(response['token'] as String);
    return ApiAuthentication.fromJson(response);
  }

  @override
  Future<ApiAuthentication> refresh() async {
    _logger.d('refresh()');

    var endpoint = Uri.parse('${RescadoConstants.api}/auth/refresh');
    var token = await RescadoStorage.getToken();
    var userAgent = await _read(deviceDataProvider).getUserAgent();
    var location = await _read(deviceDataProvider).getLocation();

    final response = await _read(httpClientProvider).postJson(
      endpoint,
      headers: <String, String>{
        HttpHeaders.userAgentHeader: userAgent,
      },
      body: location == null
          ? null
          : jsonEncode({
              'uuid': JwtDecoder.decode(token)['sub'] as String,
              'token': JwtDecoder.decode(token)['refreshToken'] as String,
              'latitude': location.latitude,
              'longitude': location.longitude,
            }),
    );

    RescadoStorage.saveToken(response['token'] as String);
    return ApiAuthentication.fromJson(response);
  }

  @override
  Future<ApiAuthentication> recover() async {
    _logger.d('recover()');

    var endpoint = Uri.parse('${RescadoConstants.api}/auth/recover');
    var token = await RescadoStorage.getToken();
    var userAgent = await _read(deviceDataProvider).getUserAgent();
    var location = await _read(deviceDataProvider).getLocation();

    final response = await _read(httpClientProvider).postJson(
      endpoint,
      headers: <String, String>{
        HttpHeaders.userAgentHeader: userAgent,
      },
      body: location == null
          ? null
          : jsonEncode({
              'uuid': JwtDecoder.decode(token)['sub'] as String,
              'latitude': location.latitude,
              'longitude': location.longitude,
            }),
    );

    RescadoStorage.saveToken(response['token'] as String);
    return ApiAuthentication.fromJson(response);
  }
}
