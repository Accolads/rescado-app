import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescado/main.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/services/animal_service.dart';
import 'package:rescado/src/views/animal_detail_view.dart';
import 'package:rescado/src/widgets/big_card.dart';
import 'package:tcard/tcard.dart';

class SwipeView extends StatefulWidget {
  const SwipeView({
    Key? key,
  }) : super(key: key);

  @override
  State<SwipeView> createState() => _SwipeViewState();
}

class _SwipeViewState extends State<SwipeView> {
  final TCardController _controller = TCardController();
  List<AnimalModel> animalModels = [];
  int _index = 0;

  @override
  void initState() {
    AnimalService.getAnimals().then((animals) {
      setState(() => animalModels.addAll(animals));
      if (animals.isNotEmpty) {
        context.read(animalController).updateCurrentAnimal(animalModels.first);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSwipe(int index, SwipInfo swipeInfo) {
    // ignore: avoid_print
    print('$index : ${swipeInfo.cardIndex}');
    if (index < animalModels.length) {
      context.read(animalController).updateCurrentAnimal(animalModels[index]);
    }

    AnimalModel swipedAnimal = animalModels[_index];
    AnimalService.processSwipe(swipedAnimal.id, swipeInfo.direction == SwipDirection.Right);

    setState(() {
      ++_index;
    });
  }

  List<BigCard> mapAnimals() {
    return animalModels
        .map(
          (AnimalModel animal) => BigCard(
            imageUrl: animal.photos.first,
            mainLabel: animal.name,
            subLabel: animal.breed,
            heroTag: '${animal.id}',
            onLike: () => _controller.forward(direction: SwipDirection.Right),
            onDislike: () => _controller.forward(direction: SwipDirection.Left),
            onTap: () => Navigator.pushNamed(context, AnimalDetailView.id),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (animalModels.isNotEmpty)
          Center(
            child: TCard(
              size: const Size(370, 570),
              cards: mapAnimals(),
              controller: _controller,
              onForward: onSwipe,
            ),
          ),
      ],
    );
  }
}
