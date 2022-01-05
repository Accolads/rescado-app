import 'package:flutter/material.dart';

// Placeholder view.
class ProfileView extends StatelessWidget {
  static const viewId = 'ProfileView';

  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text(
            'Placeholder ProfileView',
          ),
        ),
      );
}
