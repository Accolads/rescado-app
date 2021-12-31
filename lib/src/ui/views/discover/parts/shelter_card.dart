import 'package:flutter/material.dart';
import 'package:rescado/src/core/models/shelter_model.dart';
import 'package:rescado/src/ui/styles/rescado_style.dart';
import 'package:rescado/src/ui/views/shelter/shelter_view.dart';

class ShelterCard extends StatelessWidget {
  final ShelterModel shelter;

  const ShelterCard({Key? key, required this.shelter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<ShelterDetailView>(
            builder: (context) => ShelterDetailView(shelter: shelter),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 150,
                child: Image.network(
                  shelter.logo.reference,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shelter.name,
                    style: RescadoStyle.cardSmallTitle(context),
                  ),
                  Text(
                    '${shelter.city}, ${shelter.country}',
                    style: RescadoStyle.cardSubTitle(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
