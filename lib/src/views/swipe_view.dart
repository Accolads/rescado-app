import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/services/animal_service.dart';
import 'package:rescado/src/services/like_service.dart';
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
  List<AnimalModel> animals = [];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    AnimalService.getAnimals().then((a) {
      setState(() {
        animals = <AnimalModel>[...animals, ...a];
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fetchAnimals() {
    AnimalService.getAnimals().then((a) {
      setState(() {
        animals = <AnimalModel>[...animals, ...a];
      });
      
      _controller.state!.reset(cards: mapAnimals());
    });
  }

  void onSwipe(int index, SwipInfo swipeInfo) {
    if (swipeInfo.direction == SwipDirection.Right) {
      LikeService.processSwipe(animals[_index].id);
    }

    print('${animals.length} == $_index');
    if (animals.length - 5 <= _index) {
      _fetchAnimals();
    }

    ++_index;
  }

  void onLike() => _controller.forward(direction: SwipDirection.Right);

  void onDislike() => _controller.forward(direction: SwipDirection.Left);

  List<BigCard> mapAnimals() {
    return animals
        .map(
          (AnimalModel animal) => BigCard(
            imageUrl: animal.photos.first.reference,
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
        if (animals.isNotEmpty)
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
