import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rescado/src/core/providers/animal_provider.dart';
import 'package:rescado/src/core/services/api_client.dart';
import 'package:rescado/src/rescado_app.dart';
import 'package:rescado/src/ui/views/error/error_view.dart';
import 'package:rescado/src/ui/views/login/login_view.dart';
import 'package:rescado/src/ui/views/main_view.dart';
import 'package:rescado/src/ui/views/settings/settings_view.dart';

// TODO Is this the best place to instantiate ChangeNotifierProviders?
final animalProvider = ChangeNotifierProvider((ref) => AnimalProvider());

void main() async {
  const bool isRelease = bool.fromEnvironment('dart.vm.product');
  Logger.level = isRelease ? Level.warning : Level.debug;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await ApiClient().initialize();

  final Widget firstScreen;
  switch (ApiClient().status) {
    case ApiClientStatus.authenticated:
      firstScreen = MainView();
      break;
    case ApiClientStatus.expired:
      firstScreen = LoginView();
      break;
    default:
      firstScreen = ErrorView();
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
