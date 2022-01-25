import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ServerException implements Exception {
  final String message;

  ServerException({this.message = 'The server seems to be malfunctioning.'}) {
    FirebaseCrashlytics.instance.recordError(
      this,
      StackTrace.current,
      reason: 'ServerException',
    );
  }

  @override
  String toString() => 'ServerException: $message';
}
