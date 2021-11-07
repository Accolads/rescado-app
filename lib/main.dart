import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rescado/src/controllers/animal_controller.dart';
import 'package:rescado/src/services/api_client.dart';
import 'package:rescado/src/views/error_view.dart';
import 'package:rescado/src/views/login_view.dart';
import 'package:rescado/src/views/main_view.dart';

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

  final Widget firstScreen;
  switch (ApiClient().status) {
    case ApiClientStatus.authenticated:
      firstScreen = const MainView();
      break;
    case ApiClientStatus.expired:
      firstScreen = const LoginView();
      break;
    default:
      firstScreen = const ErrorView();
  }

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(
    ProviderScope(
      child: RescadoApp(
        firstScreen: firstScreen,
        settingsController: settingsController,
      ),
    ),
  );
}
