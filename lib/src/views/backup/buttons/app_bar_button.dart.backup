import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarButton extends StatelessWidget {
  final Color color;
  final String svgAsset;
  final String altText;
  final Function onPressed;

  const AppBarButton({
    Key? key,
    required this.color,
    required this.svgAsset,
    required this.altText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: SvgPicture.asset(
        svgAsset,
        color: color,
        semanticsLabel: altText,
        width: 23.0,
      ),
      onPressed: () => onPressed(),
    );
  }
}
