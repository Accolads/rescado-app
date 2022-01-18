import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BigButton extends StatelessWidget {
  final Color color;
  final String svgAsset;
  final String altText;
  final Function onPressed;

  const BigButton({
    Key? key,
    required this.color,
    required this.svgAsset,
    required this.altText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: color,
      ),
      child: SvgPicture.asset(
        svgAsset,
        color: color,
        semanticsLabel: altText,
        width: 25.0,
      ),
      onPressed: () => onPressed(),
    );
  }
}
