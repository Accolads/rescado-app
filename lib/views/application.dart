import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/constants/rescado_theme.dart';
import 'package:rescado/controllers/settings_controller.dart';
import 'package:rescado/views/splash_view.dart';

class Application extends ConsumerWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Rescado',
      restorationScopeId: 'rescado',
      theme: RescadoTheme.light,
      darkTheme: RescadoTheme.dark,
      themeMode: ref.watch(settingsControllerProvider).themeMode,
      home: const SplashView(),
    );
  }
}
