import 'package:flutter/material.dart';
import 'package:rescado/src/views/misc/swipeable_card.dart';

// Placeholder view.
class SwipeView extends StatelessWidget {
  static const viewId = 'SwipeView';

  const SwipeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(50.0),
          child: const SwipeableCard(
            imageUrl: 'https://placekitten.com/600/900',
          ),
        ),
      );
}
