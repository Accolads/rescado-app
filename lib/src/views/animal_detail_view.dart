import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rescado/main.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/styles/rescado_style.dart';
import 'package:rescado/src/widgets/animal_feature_card.dart';
import 'package:rescado/src/widgets/big_button.dart';
import 'package:rescado/src/widgets/dotted_divider.dart';
import 'package:rescado/src/widgets/image_slider.dart';
import 'package:rescado/src/widgets/shelter_info_card.dart';

class AnimalDetailView extends ConsumerWidget {
  static const id = 'AnimalDetailView';

  const AnimalDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final AnimalModel animal = watch(animalController).currentAnimal!;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            stretch: true,
            pinned: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            leading: BigButton(
              color: Theme.of(context).primaryColor,
              icon: FontAwesomeIcons.chevronLeft,
              altText: AppLocalizations.of(context)!.back,
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              BigButton(
                color: Theme.of(context).primaryColor,
                icon: FontAwesomeIcons.shareAlt,
                altText: AppLocalizations.of(context)!.back,
                onPressed: () {},
              )
            ],
            flexibleSpace: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: ImageSlider(
                    heroTag: '${animal.id}',
                    images: animal.photos,
                  ),
                ),
                Positioned(
                  child: Hero(
                    tag: '${animal.id}abc',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottom: -1,
                  left: 0,
                  right: 0,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Theme.of(context).backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              animal.name,
                              style: RescadoStyle.cardTitle(context),
                            ),
                            Text(
                              animal.breed,
                              style: RescadoStyle.cardSubTitle(context),
                            ),
                          ],
                        ),
                      ),
                      BigButton(
                        color: const Color(0xFFEE575F),
                        icon: FontAwesomeIcons.heart,
                        altText: AppLocalizations.of(context)!.likeAnimal(animal.name),
                        onPressed: () {}, //TODO how to animate?
                      ),
                    ],
                  ),
                  const SizedBox(height: 27),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimalFeatureCard(
                        mainLabel: animal.sex, //TODO
                        subLabel: AppLocalizations.of(context)!.animalSexLabel,
                      ),
                      AnimalFeatureCard(mainLabel: '${animal.age} ${AppLocalizations.of(context)!.animalYearLabel}', subLabel: AppLocalizations.of(context)!.animalAgeLabel),
                      AnimalFeatureCard(
                        mainLabel: '${animal.weight} ${AppLocalizations.of(context)!.weightKgUnit}',
                        subLabel: AppLocalizations.of(context)!.weightLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: 27),
                  ShelterInfoCard(
                    imageUrl: animal.shelter.logo,
                    mainLabel: animal.shelter.name,
                    subLabel: '${animal.shelter.city}, ${animal.shelter.country}',
                  ),
                  const DottedDivider(
                    color: Color(0xFF707070),
                  ),
                  SafeArea(
                    top: false,
                    child: Text(animal.description),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
