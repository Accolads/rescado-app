import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rescado/firebase_options.dart';
import 'package:rescado/src/application.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      // Firebase setup
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Crashlytics setup
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kDebugMode);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      // Logger setup
      Logger.level = kDebugMode ? Level.debug : Level.warning;

      // Rescado setup :-)
      runApp(
        const ProviderScope(
          child: Application(),
        ),
      );
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack),
  );
}
