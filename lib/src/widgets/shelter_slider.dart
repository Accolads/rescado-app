import 'package:flutter/material.dart';
import 'package:rescado/src/models/shelter_model.dart';
import 'package:rescado/src/services/shelter_service.dart';
import 'package:rescado/src/widgets/shelter_card.dart';

class ShelterSlider extends StatefulWidget {
  const ShelterSlider({Key? key}) : super(key: key);

  @override
  State<ShelterSlider> createState() => _ShelterSliderState();
}

class _ShelterSliderState extends State<ShelterSlider> {
  int _index = 0;
  List<ShelterModel> shelters = [];

  @override
  void initState() {
    ShelterService.getShelters().then((s) => setState(() => shelters = s));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: shelters.length,
        padEnds: false,
        controller: PageController(viewportFraction: 0.7),
        onPageChanged: (int index) => setState(() => _index = index),
        itemBuilder: (_, i) {
          return Transform.scale(
            scale: i == _index ? 1 : 0.9,
            child: ShelterCard(
              shelter: shelters[i],
            ),
          );
        },
      ),
    );
  }
}
