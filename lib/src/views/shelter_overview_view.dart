import 'package:flutter/material.dart';
import 'package:rescado/src/models/shelter_model.dart';
import 'package:rescado/src/services/shelter_service.dart';
import 'package:rescado/src/styles/rescado_style.dart';
import 'package:rescado/src/widgets/shelter_card.dart';

class ShelterOverviewView extends StatefulWidget {
  static const id = 'SheltersOverviewView';

  const ShelterOverviewView({Key? key}) : super(key: key);

  @override
  _ShelterOverviewViewState createState() => _ShelterOverviewViewState();
}

class _ShelterOverviewViewState extends State<ShelterOverviewView> {
  final List<ShelterModel> _shelters = [];

  @override
  void initState() {
    ShelterService.getShelters().then((s) {
      setState(() => _shelters.addAll(s));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Shelters',
          style: RescadoStyle.viewTitle(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
            itemCount: _shelters.length,
            itemBuilder: (_, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ShelterCard(
                  shelter: _shelters[index],
                ),
              );
            }),
      ),
    );
  }
}
