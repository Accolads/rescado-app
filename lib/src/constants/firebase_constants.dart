import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class FirebaseConstants {
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

  static FirebaseOptions get android => const FirebaseOptions(
        apiKey: String.fromEnvironment('androidFirebaseKey'),
        appId: '1:761063297605:android:8f49e3e4300426141b092c',
        messagingSenderId: '761063297605',
        projectId: 'rescado-app',
        storageBucket: 'rescado-app.appspot.com',
      );

  static FirebaseOptions get ios => const FirebaseOptions(
        apiKey: String.fromEnvironment('iosFirebaseKey'),
        appId: '1:761063297605:ios:60158da5236e7cb81b092c',
        messagingSenderId: '761063297605',
        projectId: 'rescado-app',
        storageBucket: 'rescado-app.appspot.com',
        iosClientId: '761063297605-psnfcf2b8kagmtk4pufta5tgnlea6ous.apps.googleusercontent.com',
        iosBundleId: 'org.rescado.ios',
      );
}
