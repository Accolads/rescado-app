import 'package:flutter/material.dart';

// Placeholder view.
class SwipeView extends StatelessWidget {
  static const viewId = 'SwipeView';

  const SwipeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text(
            'Placeholder SwipeView',
          ),
        ),
      );
}
