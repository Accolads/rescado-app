import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';

class PageTitle extends ConsumerWidget {
  final String label;

  const PageTitle({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w800,
              color: ref.watch(settingsControllerProvider).activeTheme.primaryColor,
            ),
          ),
        ),
      );
}
