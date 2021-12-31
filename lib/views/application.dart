import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/controllers/settings_controller.dart';

// Quick demo to test controllers. The trick is to use ConsumerWidget or HookConsumerWidget once we start animating.
class Application extends ConsumerWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Riverpod Test',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // To read a controller, just watch() it and access the fields on the state model. ☺️
      themeMode: ref.watch(settingsControllerProvider).themeMode,
      home: const ProviderTest(),
    );
  }
}

class ProviderTest extends ConsumerWidget {
  const ProviderTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Cmd+Shift+A om snel System appearance te togglen in de iOS simulator. 👍'),
              const SizedBox(height: 75.0),
              // To write to a controller, read it's notifier and you have access to its state altering methods. ☺️
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(settingsControllerProvider.notifier).setThemeMode(ThemeMode.system);
                    },
                    child: const Text('System'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(settingsControllerProvider.notifier).setThemeMode(ThemeMode.light);
                    },
                    child: const Text('Light'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(settingsControllerProvider.notifier).setThemeMode(ThemeMode.dark);
                    },
                    child: const Text('Dark'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
