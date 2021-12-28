import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:platform_info/platform_info.dart';
import 'package:rescado/src/core/services/local_storage_service.dart';
import 'package:rescado/src/util/logger.dart';

enum ApiClientStatus {
  clean, // initial status
  initializing, // when in the process of retrieving a JWT
  authenticated, // when we ready to make requests
  expired, // when we were logged in a long time ago and need to re-login
  serverError, // when the API responded in a way it shouldn't have
}

// TODO If available, add latitude/longitude to the authentication requests
class ApiClient extends http.BaseClient {
  static const String id = 'ApiClient';
  final logger = getLogger(id);

  static const String host = 'https://rescado.qrivi.dev';
  static final ApiClient _instance = ApiClient._internal();

  final Client _client = Client();
  final JsonEncoder _encoder = const JsonEncoder();
  final JsonDecoder _decoder = const JsonDecoder();

  ApiClientStatus status = ApiClientStatus.clean;
  late String authorization;
  String acceptLanguage = 'en';
  String userAgent = 'Rescado';

  factory ApiClient() => _instance;

  ApiClient._internal() {
    acceptLanguage = Platform.instance.locale.toString();

    if (Platform.instance.isAndroid) userAgent += ' for Android';
    if (Platform.instance.isIOS) userAgent += ' for iOS';
  }

  @override
  void close() {
    _client.close();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!request.url.path.startsWith('/api/auth')) {
      await _validateToken();
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $authorization';
    }

    request.headers[HttpHeaders.contentTypeHeader] = ContentType.json.mimeType;
    request.headers[HttpHeaders.acceptLanguageHeader] = acceptLanguage;
    request.headers[HttpHeaders.userAgentHeader] = userAgent;

    logger.d('Request: ${request.method} ${request.url}');
    return _client.send(request).then((response) async {
      final responseString = await response.stream.bytesToString();
      String prettyPrint = _encoder.convert(_decoder.convert(responseString));
      final _res = '''Response: ${response.request.toString()} (${response.statusCode})
      Headers: ${response.headers}
      Payload: $prettyPrint''';
      logger.d(_res.toString());
      return StreamedResponse(
        ByteStream.fromBytes(utf8.encode(responseString)),
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

  Future<void> _validateToken() async {
    if (JwtDecoder.isExpired(authorization)) {
      await _refresh();
      // If refreshing fails it can fail silently: the next request will throw an auth error that can then ben handled.
    }
  }

  Future<void> initialize() async {
    logger.i('Initializing ApiClient...');
    status = ApiClientStatus.initializing;
    try {
      authorization = await LocalStorage.getToken();
      await _refresh();
    } on ArgumentError {
      await _register();
    }
  }

  Future<void> _register() async {
    logger.i('Registering a new account...');
    Response response = await _instance.post(Uri.parse('$host/api/auth/register'));

    if (response.statusCode == 201) {
      authorization = response.headers[HttpHeaders.authorizationHeader]!.substring(7);
      status = ApiClientStatus.authenticated;
      LocalStorage.saveToken(authorization);
      logger.i('The user is now authenticated.');
      return;
    }

    status = ApiClientStatus.serverError;
    logger.e('Failed to register a new account, but this should not be possible.');
  }

  Future<void> _refresh() async {
    logger.i('Refreshing the session linked to the JWT...');
    Response response = await _instance.post(
      Uri.parse('$host/api/auth/refresh'),
      body: jsonEncode(<String, String>{
        'uuid': JwtDecoder.decode(authorization)['sub'] as String,
        'token': JwtDecoder.decode(authorization)['refreshToken'] as String,
      }),
    );

    // If we get an OK response, we also receive a JWT
    if (response.statusCode == 200) {
      authorization = response.headers[HttpHeaders.authorizationHeader]!.substring(7);
      status = ApiClientStatus.authenticated;
      LocalStorage.saveToken(authorization);
      logger.i('The user is now authenticated.');
      return;
    }

    // If we get an error response, let's look at the body
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final errors = body['errors'] as List<String>;

      // Our refresh token was expired
      if (errors.first.startsWith('[expiredToken]')) {
        logger.w('The refresh token is expired.');
        // If we were anonymous before, we can try to recover our session
        if (JwtDecoder.decode(authorization)['status'] == 'ANONYMOUS') {
          await _recover();
          return;
        }
        status = ApiClientStatus.expired;
        return;
      }

      // Other errors cannot occur unless the JWT was tampered with, so let's forget it
      LocalStorage.removeToken();
      status = ApiClientStatus.serverError;
      logger.e('Something was not right with the stored JWT.');
    } catch (e) {
      // If we can't parse the error response, something is wrong server-side
      status = ApiClientStatus.serverError;
      logger.e('The server responded with an error that could not be processed.');
    }
  }

  Future<void> _recover() async {
    logger.i('Recovering the anonymous account linked to the JWT...');
    Response response = await _instance.post(
      Uri.parse('$host/api/auth/recover'),
      body: jsonEncode(<String, String>{'uuid': JwtDecoder.decode(authorization)['sub'] as String}),
    );

    if (response.statusCode == 200) {
      authorization = response.headers[HttpHeaders.authorizationHeader]!.substring(7);
      status = ApiClientStatus.authenticated;
      LocalStorage.saveToken(authorization);
      logger.i('The user is now authenticated.');
      return;
    }

    // Recover should always work for anonymous accounts, so if we get here something must be wrong with the code
    status = ApiClientStatus.serverError;
    logger.e('Failed to recover an anonymous session, but this should not be possible.');
  }
}
