import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/exceptions/api_exception.dart';
import 'package:rescado/src/exceptions/offline_exception.dart';
import 'package:rescado/src/exceptions/server_exception.dart';
import 'package:rescado/src/services/providers/device_storage.dart';
import 'package:rescado/src/utils/logger.dart';

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient._(ref.read),
);

// Wrapper around that adds logging and some headers to requests, and logging, parsing and error handling to responses.
class ApiClient extends BaseClient {
  static final _logger = addLogger('ApiClient');

  final Reader _read;
  final Client _client = Client();

  ApiClient._(this._read);

  // Intercept BaseClient.send(), add some headers and logging.
  @override
  Future<StreamedResponse> send(BaseRequest request) {
    // Add some default headers to the request.
    request.headers[HttpHeaders.acceptLanguageHeader] = Platform.localeName;
    request.headers[HttpHeaders.acceptHeader] = ContentType.json.value;
    request.headers[HttpHeaders.contentTypeHeader] = ContentType.json.value;

    // If we're running the app during development, add some extra logs when we get a response. Hacky.
    return const bool.fromEnvironment('dart.vm.product')
        ? _client.send(request)
        : _client.send(request).then((response) async {
            final body = await response.stream.bytesToString();
            _logRequest('Response', response.request.toString(), response.statusCode, response.headers, body);
            return StreamedResponse(
              ByteStream.fromBytes(utf8.encode(body)),
              response.statusCode,
              headers: response.headers,
              reasonPhrase: response.reasonPhrase,
              persistentConnection: response.persistentConnection,
              contentLength: response.contentLength,
              isRedirect: response.isRedirect,
              request: response.request,
            );
          });
  }

  // Probably overkill.
  @override
  void close() {
    _client.close();
  }

  // BaseClient.get(), but with response processing and error handling.
  Future<Map<String, dynamic>> getJson(Uri url, {Map<String, String>? headers}) async {
    _logRequest('Request', 'GET $url', null, headers, null);
    return _parseResponse(
      () async => await super.get(url, headers: await _authIfNeeded(url, headers)).timeout(RescadoConstants.timeout),
    );
  }

  // BaseClient.post(), but with response processing and error handling.
  Future<Map<String, dynamic>> postJson(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    _logRequest('Request', 'POST $url', null, headers, body as String);
    return _parseResponse(
      () async => await super.post(url, headers: await _authIfNeeded(url, headers), body: body, encoding: encoding).timeout(RescadoConstants.timeout),
    );
  }

  // BaseClient.put(), but with response processing and error handling.
  Future<Map<String, dynamic>> putJson(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    _logRequest('Request', 'PUT $url', null, headers, body as String);
    return _parseResponse(
      () async => await super.put(url, headers: await _authIfNeeded(url, headers), body: body, encoding: encoding).timeout(RescadoConstants.timeout),
    );
  }

  // BaseClient.patch(), but with response processing and error handling.
  Future<Map<String, dynamic>> patchJson(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    _logRequest('Request', 'PATCH $url', null, headers, body as String);
    return _parseResponse(
      () async => await super.patch(url, headers: await _authIfNeeded(url, headers), body: body, encoding: encoding).timeout(RescadoConstants.timeout),
    );
  }

  // BaseClient.delete(), but with response processing and error handling.
  Future<Map<String, dynamic>> deleteJson(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    _logRequest('Request', 'DELETE $url', null, headers, body as String);
    return _parseResponse(
      () async => await super.delete(url, headers: await _authIfNeeded(url, headers), body: body, encoding: encoding).timeout(RescadoConstants.timeout),
    );
  }

  // If the url is not a public url, add the authorization header.
  Future<Map<String, String>?> _authIfNeeded(Uri url, Map<String, String>? headers) async {
    if (!url.path.contains('/auth/')) {
      final token = await _read(deviceStorageProvider).getApiToken();
      if (token != null) {
        headers ??= {};
        headers[HttpHeaders.authorizationHeader] = token.headerValue;
      }
      // If token is null (which only happens if bad programming), API will respond with missing credential error which we can then handle.
    }
    return headers;
  }

  // Function to parse the JSON returned by the server as soon as the response gets in. Also handles errors thrown by the API and wraps other exceptions if thrown.
  Future<Map<String, dynamic>> _parseResponse(Function request) async {
    try {
      final Response response = (await request()) as Response;
      // Try to parse the JSON response and wrap it in an exception to shortcut the flow if applicable.
      var body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body.containsKey('errors')) {
        throw ApiException(body['errors'] as List<String>);
      }
      // If the response contains a JWT token in the Authorization header, add it to the response we're returning.
      var authorization = response.headers[HttpHeaders.authorizationHeader];
      if (authorization != null && authorization.startsWith('Bearer ')) {
        body['jwt'] = authorization.substring(7);
      }
      return body;
    } on SocketException {
      // Wrap SocketException because this should only occur when the device is offline (I think).
      throw const OfflineException();
    } on TimeoutException {
      // Wrap TimeoutException because the error shown in the UI should be similar to when offline.
      throw const OfflineException();
    } on FormatException {
      // FormatException is thrown by jsonDecode() if it cannot parse the string passed to it (indicating the server did not respond with JSON, which it always should).
      _logger.w('The server did not respond with JSON data!');
      throw const ServerException();
    } catch (error, stackTrace) {
      // When something is very wrong.
      _logger.e('Something went very wrong', error, stackTrace);
      throw const ServerException();
    }
  }

  void _logRequest(String type, String request, int? status, Object? headers, Object? payload) {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return;
    }

    // Log as stringified JSON for easy parsing if we need to debug them.
    final prettyHeaders = headers == null
        ? 'null'
        : headers is String
            ? jsonEncode(jsonDecode(headers))
            : jsonEncode(headers);
    final prettyPayload = payload == null
        ? 'null'
        : payload is String
            ? jsonEncode(jsonDecode(payload))
            : jsonEncode(payload);

    _logger.d('''$type: $request ${status == null ? '' : '($status)'}
 ↳ Headers: $prettyHeaders
 ↳ Payload: $prettyPayload''');
  }
}
