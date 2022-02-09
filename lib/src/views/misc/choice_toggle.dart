import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';

class ChoiceToggle extends StatelessWidget {
  final String leftChoice;
  final String rightChoice;
  final bool rightActive;
  final Function onChanged;

  const ChoiceToggle({
    Key? key,
    required this.leftChoice,
    required this.rightChoice,
    required this.rightActive,
    required this.onChanged,
  }) : super(key: key);

  //TODO customize
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              leftChoice,
              style: rightActive ? null : const TextStyle(fontWeight: FontWeight.w800),
            ),
            Switch(
              activeColor: ref.watch(settingsControllerProvider).activeTheme.accentColor,
              inactiveThumbColor: ref.watch(settingsControllerProvider).activeTheme.accentColor,
              trackColor: MaterialStateProperty.all(ref.watch(settingsControllerProvider).activeTheme.borderColor),
              value: rightActive,
              onChanged: (rightActive) => onChanged(rightActive),
            ),
            Text(
              rightChoice,
              style: rightActive ? const TextStyle(fontWeight: FontWeight.w800) : null,
            ),
          ],
        );
      },
    );
  }
}
