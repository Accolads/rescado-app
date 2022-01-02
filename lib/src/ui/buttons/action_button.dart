import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rescado/src/ui/styles/rescado_style.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final String svgAsset;

  const ActionButton({Key? key, required this.label, required this.onPressed, required this.svgAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        //TODO should be in theme
        elevation: 0,
        minimumSize: const Size(160.0, 40.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        alignment: Alignment.centerLeft,
        primary: Color(0xFFFAF3DA),
        shadowColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80.0),
        ),
      ),
      icon: SvgPicture.asset(
        svgAsset,
        color: Theme.of(context).colorScheme.secondary,
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Text(
          label,
          style: RescadoStyle.actionButtonLabel(context),
        ),
      ),
      onPressed: () => onPressed(),
    );
  }
}
