import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rescado/src/widgets/page_section.dart';
import 'package:rescado/src/widgets/page_title.dart';
import 'package:rescado/src/widgets/shelter_slider.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({Key? key}) : super(key: key);

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
              const SizedBox(
                height: 24,
              ),
              PageSection(
                label: 'Dierenasielen',
                actionLabel: 'Bekijk meer',
                action: () {},
                child: const ShelterSlider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
