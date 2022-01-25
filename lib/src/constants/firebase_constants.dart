import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:rescado/src/utils/logger.dart';

class FirebaseConstants {
  static final _logger = addLogger('FirebaseConstants');

  FirebaseConstants._();

  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Bad programming. Trying to set up Firebase on unsupported platform.');
    }
  }

  static FirebaseOptions get android {
    const androidKey = String.fromEnvironment('androidFirebaseKey', defaultValue: '');

    if (androidKey.isEmpty) {
      _logger.wtf('Missing Firebase API key for Android.');
    }
    return const FirebaseOptions(
      apiKey: androidKey,
      appId: '1:761063297605:android:8f49e3e4300426141b092c',
      messagingSenderId: '761063297605',
      projectId: 'rescado-app',
      storageBucket: 'rescado-app.appspot.com',
    );
  }

  static FirebaseOptions get ios {
    const iosKey = String.fromEnvironment('iosFirebaseKey', defaultValue: '');

    if (iosKey.isEmpty) {
      _logger.wtf('Missing Firebase API key for iOS.');
    }
    return const FirebaseOptions(
      apiKey: iosKey,
      appId: '1:761063297605:ios:60158da5236e7cb81b092c',
      messagingSenderId: '761063297605',
      projectId: 'rescado-app',
      storageBucket: 'rescado-app.appspot.com',
      iosBundleId: 'org.rescado.ios',
      iosClientId: '761063297605-psnfcf2b8kagmtk4pufta5tgnlea6ous.apps.googleusercontent.com',
    );
  }
}
