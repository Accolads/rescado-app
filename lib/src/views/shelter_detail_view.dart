import 'package:flutter/material.dart';
import 'package:rescado/src/models/shelter_model.dart';
import 'package:rescado/src/styles/rescado_style.dart';

class ShelterDetailView extends StatelessWidget {
  static const id = 'ShelterDetailView';
  final ShelterModel shelter;

  const ShelterDetailView({Key? key, required this.shelter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).primaryColor,
        title: Text(
          shelter.name,
          style: RescadoStyle.viewTitle(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: Center(
        child: Text(
          shelter.city,
        ),
      ),
    );
  }
}
