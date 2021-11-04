import 'package:flutter/material.dart';
import 'package:rescado/src/styles/rescado_style.dart';

// Placeholder view. Will be completely replaced when implemented.
class LoginView extends StatelessWidget {
  static const id = 'LoginView';

  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).primaryColor,
        title: Text(
          'LoginView',
          style: RescadoStyle.viewTitle(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: const Center(
        child: Text(
          'login',
        ),
      ),
    );
  }
}
