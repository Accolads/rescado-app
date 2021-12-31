import 'package:flutter/material.dart';
import 'package:rescado/src/ui/styles/rescado_style.dart';

class AnimalFeatureCard extends StatelessWidget {
  final String mainLabel;
  final String subLabel;

  const AnimalFeatureCard({Key? key, required this.mainLabel, required this.subLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.50),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            mainLabel,
            style: const TextStyle(
              // TODO text style from theme
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subLabel,
            style: RescadoStyle.cardSubTitle(context),
          )
        ],
      ),
    );
  }
}
