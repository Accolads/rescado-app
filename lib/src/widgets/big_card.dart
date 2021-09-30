import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  final String label;
  final String sublabel;

  const BigCard({Key? key, required this.label, required this.sublabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
