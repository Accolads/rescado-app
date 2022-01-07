import 'package:flutter/material.dart';

// Placeholder view.
class AuthenticationView extends StatelessWidget {
  static const viewId = 'AuthenticationView';

  const AuthenticationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Text(
            'Placeholder AuthenticationView',
          ),
        ),
      );
}
