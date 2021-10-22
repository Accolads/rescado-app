import 'dart:convert';
import 'dart:io';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:platform_info/platform_info.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:rescado/src/services/local_storage_service.dart';

class ApiClient extends http.BaseClient {
  static final ApiClient _instance = ApiClient._internal();
  final Client _client = Client();

  static const String host = 'http://localhost:8282';

  late String authorization;
  String acceptLanguage = 'en';
  String userAgent = 'Rescado';

  factory ApiClient() => _instance;

  ApiClient._internal() {
    acceptLanguage = Platform.instance.locale.toString();

    if (Platform.instance.isAndroid) userAgent += ' for Android';
    if (Platform.instance.isIOS) userAgent += ' for iOS';
  }

  Future<void> initializeToken() async {
    try {
      authorization = await LocalStorage.getToken();
    } on ArgumentError {
      await _register();
    }
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!request.url.path.startsWith('/api/auth')) {
      await _validateToken();
      request.headers['Authorization'] = 'Bearer $authorization';
    }

    if (request.method == 'POST') {
      request.headers[HttpHeaders.contentTypeHeader] = ContentType.json.mimeType;
    }

    request.headers[HttpHeaders.acceptLanguageHeader] = acceptLanguage;
    request.headers[HttpHeaders.userAgentHeader] = userAgent;

    return _client.send(request);
  }

  Future<void> _validateToken() async {
    if (JwtDecoder.isExpired(authorization)) {
      await _refresh();
    }
  }

  Future<void> _register() async {
    Response response = await _instance.post(Uri.parse('$host/api/auth/register'));
    if (response.statusCode == 201) {
      authorization = response.headers[HttpHeaders.authorizationHeader]!.substring(7);
      LocalStorage.saveToken(authorization);
    }
    //TODO else navigate to ServerError view
  }

  Future<void> _refresh() async {
    Response response = await _instance.post(
      Uri.parse('$host/api/auth/refresh'),
      body: jsonEncode(<String, String>{
        'uuid': JwtDecoder.decode(authorization)['sub'] as String,
        'token': authorization,
      }),
    );

    if (response.statusCode == 200) {
      authorization = response.headers[HttpHeaders.authorizationHeader]!.substring(8);
      LocalStorage.saveToken(authorization);
    }
    //TODO else navigate to login view
  }
}
