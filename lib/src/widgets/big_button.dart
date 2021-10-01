import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BigButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String altText;
  final Function onPressed;

  const BigButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.altText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: color,
      ),
      child: FaIcon(
        icon,
        color: color,
        semanticLabel: altText,
        size: 25.0,
      ),
      onPressed: () => onPressed,
    );
  }
}
