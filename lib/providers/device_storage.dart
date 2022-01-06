import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/models/api_token.dart';
import 'package:rescado/utils/logger.dart';
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

  final _apiTokenKey = 'apiToken';
  ApiToken? _apiTokenCache;

  Future<ApiToken?> getApiToken() async {
    _logger.d('getApiToken()');
    if (_apiTokenCache == null) {
      String? apiToken = (await SharedPreferences.getInstance()).getString(_apiTokenKey);
      _apiTokenCache = apiToken == null ? null : ApiToken.fromJwt(apiToken);
    }
    return _apiTokenCache;
  }

  void saveApiToken(ApiToken? apiToken) async {
    _logger.d('saveApiToken()');
    _apiTokenCache = apiToken;
    final sharedPreferences = await SharedPreferences.getInstance();
    if (apiToken == null) {
      sharedPreferences.remove(_apiTokenKey);
    } else {
      sharedPreferences.setString(_apiTokenKey, apiToken.jwt);
    }
  }

/* endregion */
}
