import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/token.dart';
import 'package:rescado/src/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final deviceStorageProvider = Provider<DeviceStorage>(
  (ref) => DeviceStorage._(),
);

class DeviceStorage {
  static final _logger = addLogger('DeviceStorage');

  DeviceStorage._();

  /* region themeMode */

  final _themeModeKey = 'themeMode';
  ThemeMode? _themeModeCache;

  Future<ThemeMode> getThemeMode() async {
    _logger.d('getThemeMode()');
    if (_themeModeCache == null) {
      String? themeMode = (await SharedPreferences.getInstance()).getString(_themeModeKey);
      _themeModeCache = themeMode == null ? ThemeMode.system : ThemeMode.values.byName(themeMode);
    }
    return _themeModeCache!;
  }

  void saveThemeMode(ThemeMode? themeMode) async {
    _logger.d('saveThemeMode()');
    _themeModeCache = themeMode;
    final sharedPreferences = await SharedPreferences.getInstance();
    if (themeMode == null) {
      sharedPreferences.remove(_themeModeKey);
    } else {
      sharedPreferences.setString(_themeModeKey, themeMode.name);
    }
  }

  /* endregion */
  /* region token */

  final _tokenKey = 'token';
  Token? _tokenCache;

  Future<Token?> getToken() async {
    _logger.d('getToken()');
    if (_tokenCache == null) {
      String? token = (await SharedPreferences.getInstance()).getString(_tokenKey);
      _tokenCache = token == null ? null : Token.fromJwt(token);
    }
    return _tokenCache;
  }

  void saveToken(Token? token) async {
    _logger.d('saveToken()');
    _tokenCache = token;
    final sharedPreferences = await SharedPreferences.getInstance();
    if (token == null) {
      sharedPreferences.remove(_tokenKey);
    } else {
      sharedPreferences.setString(_tokenKey, token.jwt);
    }
  }

/* endregion */
}
