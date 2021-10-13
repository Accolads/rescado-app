import 'package:flutter/material.dart';

class ShelterDetailView extends StatelessWidget {
  static const id = 'ShelterDetailView';

  const ShelterDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Shelter detail view',
        ),
      ),
    );
  }
}
