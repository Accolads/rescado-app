import 'package:flutter/material.dart';

class SimpleTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  const SimpleTooltip({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Tooltip(
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 2.0,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 12.0,
        ),
        textStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        enableFeedback: true,
        preferBelow: false,
        message: message,
        child: child,
      );
}
