import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rescado/src/services/api_client.dart';
import 'package:rescado/src/settings/settings_controller.dart';
import 'package:rescado/src/styles/rescado_theme.dart';
import 'package:rescado/src/views/error_view.dart';
import 'package:rescado/src/views/likes_view.dart';
import 'package:rescado/src/views/login_view.dart';
import 'package:rescado/src/views/main_view.dart';

class RescadoApp extends StatelessWidget {
  final SettingsController settingsController;

  const RescadoApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget firstScreen;

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

    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
          theme: RescadoTheme.light,
          darkTheme: RescadoTheme.dark,
          themeMode: settingsController.themeMode,
          home: firstScreen,
          routes: {
            MainView.id: (context) => const MainView(),
            LikesView.id: (context) => const LikesView(),
          },
        );
      },
    );
  }
}
