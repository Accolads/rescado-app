import 'package:flutter/material.dart';

// Placeholder view.
class DiscoverView extends StatelessWidget {
  static const viewId = 'DiscoverView';

  const DiscoverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text(
            'Placeholder DiscoverView',
          ),
        ),
      );
}
