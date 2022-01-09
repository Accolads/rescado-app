import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/custom_theme.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/views/authentication_view.dart';
import 'package:rescado/src/views/main_view.dart';
import 'package:rescado/src/views/splash_view.dart';

class Application extends ConsumerWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Rescado',
      restorationScopeId: 'rescado',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme:  ref.watch(settingsControllerProvider).lightTheme.themeData,
      darkTheme:  ref.watch(settingsControllerProvider).darkTheme.themeData,
      themeMode: ref.watch(settingsControllerProvider).themeMode,
      home: const SplashView(),
      routes: {
        AuthenticationView.viewId: (context) => const AuthenticationView(),
        MainView.viewId: (context) => const MainView(),
        SplashView.viewId: (context) => const SplashView(),
      },
    );
  }
}
