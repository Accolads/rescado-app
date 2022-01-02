import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/controllers/settings_controller.dart';
import 'package:rescado/views/swipeable_card.dart';

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
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20.0),
          child: SwipeableCard(
            imageUrl: 'https://placekitten.com/600/900?${Random()..nextInt(100)}',
          ),
        ),
      ),
    );
  }
}
