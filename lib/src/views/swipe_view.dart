import 'package:flutter/material.dart';
import 'package:rescado/src/views/misc/swipeable_stack.dart';

// Placeholder view.
class SwipeView extends StatelessWidget {
  static const viewId = 'SwipeView';
  static const tabIndex = 1;

  const SwipeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SwipeableStack(),
        ),
      );
}
