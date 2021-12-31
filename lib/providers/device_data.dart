import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deviceDataProvider = Provider<DeviceData>((ref) => DeviceData());

class DeviceData {
  bool _askedForLocationPermission = false;

  // Gets the device's current location coordinates.
  Future<Position?> getLocation() async {
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
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  // Gets the device's "user agent"
  Future<String> getUserAgent() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      return '$manufacturer $model (Android $release)'; // eg. Xiaomi Redmi Note 7 (Android 10)
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      // var model = iosInfo.model; // Always "iPhone", but included in $name.
      return 'Apple $name ($systemName $version)'; // eg. Apple iPhone 12 Pro (iOS 15.1)
    }

    return 'Unknown Device';
  }

  // Gets the device's current locale.
  Future<String> getLocale() async {
    return Future.value(Platform.localeName);
  }
}
