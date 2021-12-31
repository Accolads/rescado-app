import 'package:flutter/material.dart';
import 'package:rescado/src/core/models/shelter_model.dart';
import 'package:rescado/src/ui/styles/rescado_style.dart';
import 'package:rescado/src/util/logger.dart';

// Placeholder view. Will be completely replaced when implemented.
class ShelterDetailView extends StatelessWidget {
  static const id = 'ShelterView';
  final logger = getLogger(id);

  final ShelterModel shelter;

  ShelterDetailView({Key? key, required this.shelter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('build()');
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
