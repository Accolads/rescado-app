import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/models/shelter_model.dart';
import 'package:rescado/src/services/animal_service.dart';
import 'package:rescado/src/services/shelter_service.dart';
import 'package:rescado/src/views/shelter_overview_view.dart';
import 'package:rescado/src/widgets/page_section.dart';
import 'package:rescado/src/widgets/page_title.dart';
import 'package:rescado/src/widgets/shelter_slider.dart';
import 'package:rescado/src/widgets/spotlight_overview.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({Key? key}) : super(key: key);

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  List<AnimalModel> _spotlightAnimals = [];
  List<ShelterModel> _shelters = [];

  @override
  void initState() {
    //TODO this is going to be 1 call?
    AnimalService.getAnimals().then((a) => setState(() => _spotlightAnimals = a));
    ShelterService.getShelters().then((s) => setState(() => _shelters = s));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.0),
          child: Column(
            children: [
              PageTitle(
                label: AppLocalizations.of(context)!.tabbarDiscover,
              ),
              PageSection(
                label: 'Nieuws',
                actionLabel: 'Bekijk meer',
                action: () {},
                child: const SizedBox(
                  height: 50,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              if (_spotlightAnimals.length >= 3)
                PageSection(
                  label: 'Spotlight',
                  child: SpotlightOverview(
                    animals: _spotlightAnimals,
                  ),
                ),
              PageSection(
                label: 'Dierenasielen',
                actionLabel: 'Bekijk meer',
                action: () => Navigator.pushNamed(context, ShelterOverviewView.id),
                child: ShelterSlider(
                  shelters: _shelters,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
