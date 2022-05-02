import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/views/misc/simple_tooltip.dart';

enum RoundedButtonSize {
  small,
  big,
}

class RoundedButton extends ConsumerWidget {
  final Color? color;
  final RoundedButtonSize? size;
  final String semanticsLabel;
  final String svgAsset;
  final Function onPressed;

  Size get _size {
    switch (size) {
      case RoundedButtonSize.big:
        return const Size.square(60.0);
      case RoundedButtonSize.small:
      default:
        return const Size.square(45.0);
    }
  }

  const RoundedButton({
    Key? key,
    this.color,
    this.size,
    required this.semanticsLabel,
    required this.svgAsset,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: ref.watch(settingsControllerProvider).activeTheme.backgroundColor,
          shadowColor: color ?? ref.watch(settingsControllerProvider).activeTheme.accentColor,
          minimumSize: _size,
          shape: const CircleBorder(),
          splashFactory: NoSplash.splashFactory,
        ).merge(
          ButtonStyle(
            elevation: MaterialStateProperty.resolveWith<double>(
              (Set<MaterialState> states) => states.contains(MaterialState.pressed) ? 3.0 : 1.0,
            ),
          ),
        ),
        onPressed: () => onPressed(),
        child: SimpleTooltip(
          message: semanticsLabel,
          child: SvgPicture.asset(
            svgAsset,
            color: color ?? ref.watch(settingsControllerProvider).activeTheme.accentColor,
            fit: BoxFit.contain,
          ),
        ),
      );
}
