import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rescado/src/ui/styles/rescado_theme.dart';
import 'package:rescado/src/ui/views/discover/parts/shelter_overview_view.dart';
import 'package:rescado/src/ui/views/main_view.dart';
import 'package:rescado/src/ui/views/profile/parts/likes_view.dart';
import 'package:rescado/src/ui/views/settings/settings_view.dart';
import 'package:rescado/src/util/logger.dart';

class RescadoApp extends StatelessWidget {
  static const id = 'RescadoApp';
  final logger = getLogger(id);

  final Widget firstScreen;
  final SettingsController settingsController;

  RescadoApp({
    Key? key,
    required this.firstScreen,
    required this.settingsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('build()');
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
            MainView.id: (context) => MainView(),
            LikesView.id: (context) => const LikesView(),
            ShelterOverviewView.id: (context) => const ShelterOverviewView(),
          },
        );
      },
    );
  }
}
