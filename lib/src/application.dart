import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/views/animal_view.dart';
import 'package:rescado/src/views/authentication_view.dart';
import 'package:rescado/src/views/edit_profile_view.dart';
import 'package:rescado/src/views/main_view.dart';
import 'package:rescado/src/views/splash_view.dart';

class Application extends ConsumerWidget {
  const Application({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
        title: 'Rescado',
        restorationScopeId: 'rescado',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ref.watch(settingsControllerProvider).lightTheme.themeData,
        darkTheme: ref.watch(settingsControllerProvider).darkTheme.themeData,
        themeMode: ref.watch(settingsControllerProvider).themeMode,
        home: const SplashView(),
        routes: {
          AnimalView.viewId: (context) => const AnimalView(),
          AuthenticationView.viewId: (context) => const AuthenticationView(),
          EditProfileView.viewId: (context) => const EditProfileView(),
          MainView.viewId: (context) => const MainView(),
          SplashView.viewId: (context) => const SplashView(),
        },
      );
}
