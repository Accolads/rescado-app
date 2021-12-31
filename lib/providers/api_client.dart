import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rescado/constants/rescado_constants.dart';
import 'package:rescado/constants/rescado_storage.dart';
import 'package:rescado/exceptions/api_exception.dart';
import 'package:rescado/exceptions/offline_exception.dart';
import 'package:rescado/exceptions/server_exception.dart';
import 'package:rescado/utils/logger.dart';

final httpClientProvider = Provider<ApiClient>((ref) => ApiClient());

// Wrapper around http that adds logging and some headers to requests, and logging, parsing and error handling to responses.
class ApiClient extends http.BaseClient {
  static final _logger = addLogger('HttpClient');

  final http.Client _client = http.Client();

  // Intercept BaseClient.send(), add some headers and logging.
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // Add some default headers to the request.
    request.headers[HttpHeaders.acceptLanguageHeader] = Platform.localeName;
    request.headers[HttpHeaders.acceptHeader] = ContentType.json.value;
    request.headers[HttpHeaders.contentTypeHeader] = ContentType.json.value;

    // Log the request method and URL, then make the request.
    _logger.d('Request: ${request.method} ${request.url}');
    if (const bool.fromEnvironment('dart.vm.product')) {
      return _client.send(request);
    }
    // If we're running the app during development, add some extra logs when we get a response.
    return _client.send(request).then((response) async {
      final responseString = await response.stream.bytesToString();
      String prettyPrint = jsonEncode(jsonDecode(responseString));
      final _res = '''Response: ${response.request.toString()} (${response.statusCode})
      Headers: ${response.headers}
      Payload: $prettyPrint''';
      _logger.d(_res.toString());
      return http.StreamedResponse(
        http.ByteStream.fromBytes(utf8.encode(responseString)),
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
  Future<Map<String, dynamic>> getJson(Uri url, {Map<String, String>? headers}) async => _parseResponse(
        await super.get(url, headers: await _authIfNeeded(url, headers)).timeout(RescadoConstants.timeout),
      );

  // BaseClient.post(), but with response processing and error handling.
  Future<Map<String, dynamic>> postJson(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async => _parseResponse(
        await super.post(url, headers: await _authIfNeeded(url, headers), body: body, encoding: encoding).timeout(RescadoConstants.timeout),
      );

  // BaseClient.put(), but with response processing and error handling.
  Future<Map<String, dynamic>> putJson(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async => _parseResponse(
        await super.put(url, headers: await _authIfNeeded(url, headers), body: body, encoding: encoding).timeout(RescadoConstants.timeout),
      );

  // BaseClient.patch(), but with response processing and error handling.
  Future<Map<String, dynamic>> patchJson(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async => _parseResponse(
        await super.patch(url, headers: await _authIfNeeded(url, headers), body: body, encoding: encoding).timeout(RescadoConstants.timeout),
      );

  // BaseClient.delete(), but with response processing and error handling.
  Future<Map<String, dynamic>> deleteJson(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async => _parseResponse(
        await super.delete(url, headers: await _authIfNeeded(url, headers), body: body, encoding: encoding).timeout(RescadoConstants.timeout),
      );

  // If the url is not a public url, add the authorization header.
  Future<Map<String, String>?> _authIfNeeded(Uri url, Map<String, String>? headers) async {
    if (!url.path.contains('/auth/')) {
      headers ??= {};
      headers[HttpHeaders.authorizationHeader] = 'Bearer ${(await RescadoStorage.getToken()) ?? 'no-token-in-storage'}';
    }
    return headers;
  }

  // Function to parse the JSON returned by the server as soon as the response gets in. Also handles errors thrown by the API and wraps other exceptions if thrown.
  Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      // Try to parse the JSON response and wrap it in an exception to shortcut the flow if applicable.
      var body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body.containsKey('errors')) {
        throw ApiException(body['errors'] as List<String>);
      }
      // If the response contains a JWT token in the Authorization header, add it to the response we're returning.
      var authorization = response.headers[HttpHeaders.authorizationHeader];
      if (authorization != null && authorization.startsWith('Bearer ')) {
        body['token'] = authorization.substring(7);
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
      _logger.e('The server did not respond with JSON data!');
      _logger.d(response.body);
      throw const ServerException();
    } catch (error, stackTrace) {
      // When something is very wrong.
      _logger.e('Something went very wrong', error, stackTrace);
      throw const ServerException();
    }
  }
}
