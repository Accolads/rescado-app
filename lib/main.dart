import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rescado/src/application.dart';

void main() {
  const bool isRelease = bool.fromEnvironment('dart.vm.product');
  Logger.level = isRelease ? Level.warning : Level.debug;

  runApp(
    const ProviderScope(
      child: Application(),
    ),
  );
}
