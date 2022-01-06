import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rescado/utils/logger.dart';

final deviceDataProvider = Provider<DeviceData>(
  (ref) => DeviceData._(),
);

class DeviceData {
  static final _logger = addLogger('DeviceData');

  bool _askedForLocationPermission = false;

  DeviceData._();

  // Gets the device's current location coordinates.
  Future<Position?> getLocation() async {
    _logger.d('getLocation()');

    // If location services are disabled, we can return null straightaway.
    if (!(await Geolocator.isLocationServiceEnabled())) {
      return null;
    }
    // Check if we have permission to get the device's location.
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return null;
    }
    // If we don't have permission but we haven't requested it yet this session, do so now.
    if (permission == LocationPermission.denied && !_askedForLocationPermission) {
      _askedForLocationPermission = true;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  // Gets the device's friendly name
  Future<String> getDeviceName() async {
    _logger.d('getDeviceName()');

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final release = androidInfo.version.release;
      final manufacturer = androidInfo.manufacturer;
      final model = androidInfo.model;
      return '$manufacturer $model (Android $release)'; // eg. Xiaomi Redmi Note 7 (Android 10)
    }

    if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      final systemName = iosInfo.systemName;
      final version = iosInfo.systemVersion;
      final name = iosInfo.name;
      // var model = iosInfo.model; // Seems to always be "iPhone", but that's already included in $name.
      return 'Apple $name ($systemName $version)'; // eg. Apple iPhone 12 Pro (iOS 15.1)
    }

    return 'Unknown';
  }

  // Gets the device's user-agent
  Future<String> getUserAgent() async {
    _logger.d('getUserAgent()');

    final info = await PackageInfo.fromPlatform();
    final name = info.appName;
    final version = info.version;
    return '$name v$version (${await getBuild()})';
  }

  // Gets the device's build "number"
  Future<String> getBuild() async {
    _logger.d('getUserAgent()');

    final info = await PackageInfo.fromPlatform();
    final build = info.buildNumber;
    final version = info.version;
    return build == version ? 'SNAPSHOT' : build;
    // This is a workaround. I don't know why device_info_plus does not properly parse build if it's a string
  }

  // Gets the device's current locale.
  Future<String> getLocale() async {
    _logger.d('getLocale()');

    return Future.value(Platform.localeName);
  }
}
