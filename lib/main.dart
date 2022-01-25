import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rescado/firebase_options.dart'; // ignore: uri_does_not_exist
import 'package:rescado/src/application.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ignore: argument_type_not_assignable, undefined_identifier
  );

  // Crashlytics setup
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Logger setup
  Logger.level = kDebugMode ? Level.debug : Level.warning;

  runZonedGuarded(() {
    runApp(
      const ProviderScope(
        child: Application(),
      ),
    );
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
