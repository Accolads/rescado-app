import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rescado/src/styles/rescado_theme.dart';
import 'package:rescado/src/views/animal_detail_view.dart';
import 'package:rescado/src/views/main_view.dart';
import 'package:rescado/src/settings/settings_controller.dart';
import 'package:rescado/src/views/shelter_detail_view.dart';

class RescadoApp extends StatelessWidget {
  const RescadoApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
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
          home: const MainView(),
          routes: {
            MainView.id: (context) => const MainView(),
            AnimalDetailView.id: (context) => const AnimalDetailView(),
            ShelterDetailView.id: (context) => const ShelterDetailView(),
          },
        );
      },
    );
  }
}
