import 'package:flutter/material.dart';
import 'package:rescado/src/models/shelter_model.dart';
import 'package:rescado/src/services/shelter_service.dart';
import 'package:rescado/src/widgets/shelter_card.dart';

class ShelterSlider extends StatefulWidget {
  final List<ShelterModel> shelters;

  const ShelterSlider({required this.shelters, Key? key}) : super(key: key);

  @override
  State<ShelterSlider> createState() => _ShelterSliderState();
}

class _ShelterSliderState extends State<ShelterSlider> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: widget.shelters.length,
        padEnds: false,
        controller: PageController(viewportFraction: 0.7),
        onPageChanged: (int index) => setState(() => _index = index),
        itemBuilder: (_, i) {
          return Transform.scale(
            scale: i == _index ? 1 : 0.9,
            child: ShelterCard(
              shelter: widget.shelters[i],
            ),
          );
        },
      ),
    );
  }
}
