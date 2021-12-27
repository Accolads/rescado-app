import 'package:flutter/material.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/styles/rescado_style.dart';
import 'package:rescado/src/views/animal_detail_view.dart';

class AnimalSpotlightCard extends StatelessWidget {
  final AnimalModel animal;

  const AnimalSpotlightCard({
    required this.animal,
    Key? key,
  }) : super(key: key);

  void onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => AnimalDetailView(
          animal: animal,
          renderLike: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        height: 165,
        width: 110,
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 5),
              blurRadius: 15.0,
              spreadRadius: 1.0,
              color: Color(0x1A000000),
            )
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 126,
              width: 100,
              child: Hero(
                tag: 'HeroTag_${animal.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    animal.photos.first.reference,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              animal.name,
              style: RescadoStyle.cardSmallTitle(context).copyWith(
                color: Theme.of(context).primaryColor, //TODO
              ),
            ),
          ],
        ),
      ),
    );
  }
}
