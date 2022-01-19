import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';

// Fixed width (!) button with icon and label. Should only be used for small command-like labels.
class ActionButton extends ConsumerWidget {
  final String label;
  final String svgAsset;
  final Function onPressed;

  final double _borderRadius = 50.0;

  const ActionButton({
    Key? key,
    required this.label,
    required this.svgAsset,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
        width: 160.0, // Button max width
        child: Material(
          color: ref.watch(settingsControllerProvider).activeTheme.accentDimmedColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(_borderRadius),
            splashColor: Platform.isAndroid ? ref.watch(settingsControllerProvider).activeTheme.accentColor.withOpacity(.2) : Colors.transparent,
            highlightColor: Platform.isAndroid ? Colors.transparent : ref.watch(settingsControllerProvider).activeTheme.accentColor.withOpacity(.2),
            onTap: () => onPressed(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: SvgPicture.asset(
                      // TODO Make this SVG wiggle when the button is being held down :-)
                      svgAsset,
                      color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
                      fit: BoxFit.contain,
                    ),
                  ),
             const     SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    label,
                    style: RescadoConstants.actionLabel,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
