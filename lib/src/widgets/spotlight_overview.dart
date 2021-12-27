import 'package:flutter/material.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/widgets/animal_spotlight_card.dart';

class SpotlightOverview extends StatelessWidget {
  final List<AnimalModel> animals;

  const SpotlightOverview({required this.animals, Key? key})
      : assert(animals.length >= 3),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          Positioned(
            left: 1,
            top: 14,
            child: Transform.rotate(
              angle: -0.12,
              child: AnimalSpotlightCard(
                animal: animals[0],
              ),
            ),
          ),
          Positioned(
            right: 1,
            top: 14,
            child: Transform.rotate(
              angle: 0.12,
              child: AnimalSpotlightCard(
                animal: animals[1],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: AnimalSpotlightCard(
                animal: animals[2],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
