import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescado/main.dart';
import 'package:rescado/src/core/models/animal_model.dart';
import 'package:rescado/src/core/services/animal_service.dart';
import 'package:rescado/src/core/services/like_service.dart';
import 'package:rescado/src/ui/cards/big_card.dart';
import 'package:rescado/src/ui/views/animal/animal_view.dart';
import 'package:rescado/src/util/logger.dart';
import 'package:tcard/tcard.dart';

class SwipeView extends ConsumerStatefulWidget {
  static const id = 'SwipeView';
  final logger = getLogger(id);

  SwipeView({
    Key? key,
  }) : super(key: key);

  @override
  _SwipeViewState createState() => _SwipeViewState();
}

class _SwipeViewState extends ConsumerState<SwipeView> {
  final TCardController _controller = TCardController();
  List<AnimalModel> animals = [];

  Future<void> fetchNewAnimals() async {
    List<AnimalModel> newAnimals = await AnimalService.getAnimals();

    setState(() {
      animals = [...animals, ...newAnimals];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNewAnimals();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSwipe(int index, SwipInfo swipeInfo) {
    if (swipeInfo.direction == SwipDirection.Right) {
      LikeService.processSwipe(animals.first.id);
    }

    animals.removeAt(0);
    if (animals.length <= 5) {
      fetchNewAnimals();
    }
    _controller.reset(cards: _buildCards(animals));
  }

  void onReturnAnimal() async {
    bool likedCurrent = ref.read(animalProvider).likedCurrentAnimal;
    if (likedCurrent) {
      //TODO find better solution
      await Future.delayed(const Duration(milliseconds: 50), () {});
      _controller.forward(direction: SwipDirection.Right);
      ref.read(animalProvider).resetLikedCurrentAnimal();
    }
  }

  List<BigCard> _buildCards(List<AnimalModel> animals) {
    return animals
        .map((animal) => BigCard(
              imageUrl: animal.photos.first.reference,
              mainLabel: animal.name,
              subLabel: animal.breed,
              heroTag: '${animal.id}',
              onLike: () => _controller.forward(direction: SwipDirection.Right),
              onDislike: () => _controller.forward(direction: SwipDirection.Left),
              onTap: () => Navigator.of(context)
                  .push(
                    MaterialPageRoute<bool>(
                      builder: (_) => AnimalView(
                        animal: animal,
                        renderLike: true,
                      ),
                    ),
                  )
                  .then((_) => onReturnAnimal()),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    widget.logger.d('build()');
    return Column(
      children: <Widget>[
        if (animals.isNotEmpty)
          Center(
            child: TCard(
              delaySlideFor: 250,
              size: const Size(370, 570),
              cards: _buildCards(animals),
              controller: _controller,
              onForward: onSwipe,
            ),
          ),
      ],
    );
  }
}
