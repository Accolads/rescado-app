import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/views/misc/simple_tooltip.dart';

class AppBarButton extends ConsumerWidget {
  final String semanticsLabel;
  final String svgAsset;
  final bool opaque;
  final Function onPressed;

  final _size = 45.0;

  const AppBarButton({
    Key? key,
    required this.semanticsLabel,
    required this.svgAsset,
    this.opaque = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: opaque ? ref.watch(settingsControllerProvider).activeTheme.backgroundColor : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SimpleTooltip(
              message: semanticsLabel,
              child: SvgPicture.asset(
                svgAsset,
                color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
