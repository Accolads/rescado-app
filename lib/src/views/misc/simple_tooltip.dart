import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';

class SimpleTooltip extends ConsumerWidget {
  final String message;
  final Widget child;

  const SimpleTooltip({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Tooltip(
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 2.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 12.0,
        ),
        textStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: ref.watch(settingsControllerProvider).activeTheme.primaryInvertedColor,
        ),
        enableFeedback: true,
        preferBelow: false,
        message: message,
        child: child,
      );
}
