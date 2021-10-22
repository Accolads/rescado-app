import 'package:flutter/material.dart';
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
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSwipe(int index, SwipInfo swipeInfo) {
    AnimalModel swipedAnimal = animalModels[_index];
    if (swipeInfo.direction == SwipDirection.Right) AnimalService.processSwipe(swipedAnimal.id);

    setState(() => ++_index);
  }

  void onLike() => _controller.forward(direction: SwipDirection.Right);

  void onDislike() => _controller.forward(direction: SwipDirection.Left);

  List<BigCard> mapAnimals() {
    return animalModels
        .map(
          (AnimalModel animal) => BigCard(
            imageUrl: animal.photos.first,
            mainLabel: animal.name,
            subLabel: animal.breed,
            heroTag: '${animal.id}',
            onLike: () => onLike(),
            onDislike: () => onDislike(),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<AnimalDetailView>(
                builder: (context) => AnimalDetailView(
                  animal: animal,
                  onLike: onLike,
                ),
              ),
            ),
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
