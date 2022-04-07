import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rescado/src/application.dart';
import 'package:rescado/src/constants/firebase_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase setup
  await Firebase.initializeApp(
    options: FirebaseConstants.currentPlatform,
  );

  // Crashlytics setup
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Logger setup
  Logger.level = kReleaseMode ? Level.warning : Level.debug;

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
