import 'package:flutter/material.dart';

class AnimalFeatureCard extends StatelessWidget {
  final String mainLabel;
  final String subLabel;

  const AnimalFeatureCard({Key? key, required this.mainLabel, required this.subLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: const Color(0x88FBD45C), //TODO color from theme
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            mainLabel,
            style: const TextStyle(
              // TODO text style from theme
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
