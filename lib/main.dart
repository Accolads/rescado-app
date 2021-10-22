import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescado/src/controllers/animal_controller.dart';
import 'package:rescado/src/services/api_client.dart';

import 'src/rescado_app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

//todo where
final animalController = ChangeNotifierProvider((ref) => AnimalController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  await ApiClient().initializeToken();

  runApp(
    ProviderScope(
      child: RescadoApp(settingsController: settingsController),
    ),
  );
}
