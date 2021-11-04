import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rescado/src/controllers/animal_controller.dart';
import 'package:rescado/src/services/api_client.dart';

import 'src/rescado_app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

// TODO Is this the best place to instantiate ChangeNotifierProviders?
final animalController = ChangeNotifierProvider((ref) => AnimalController());

void main() async {
  const bool isRelease = bool.fromEnvironment('dart.vm.product');
  Logger.level = isRelease ? Level.warning : Level.debug;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await ApiClient().initialize();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(
    ProviderScope(
      child: RescadoApp(settingsController: settingsController),
    ),
  );
}
