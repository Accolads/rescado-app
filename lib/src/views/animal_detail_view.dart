import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rescado/main.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/styles/rescado_style.dart';
import 'package:rescado/src/widgets/animal_feature_card.dart';
import 'package:rescado/src/widgets/app_bar_button.dart';
import 'package:rescado/src/widgets/big_button.dart';
import 'package:rescado/src/widgets/dotted_divider.dart';
import 'package:rescado/src/widgets/image_slider.dart';
import 'package:rescado/src/widgets/shelter_info_card.dart';

class AnimalDetailView extends ConsumerWidget {
  static const id = 'AnimalDetailView';

  final AnimalModel animal;
  final bool renderLike;

  const AnimalDetailView({Key? key, required this.animal, required this.renderLike}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor, // required for clean Hero animation and bottom overflow on iOS
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            stretch: true,
            pinned: false,
            expandedHeight: MediaQuery.of(context).size.height / 2,
            leadingWidth: 56,
            toolbarHeight: 46,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: AppBarButton(
                color: Theme.of(context).primaryColor,
                icon: FontAwesomeIcons.chevronLeft,
                altText: AppLocalizations.of(context)!.back,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: AppBarButton(
                    color: Theme.of(context).primaryColor,
                    icon: FontAwesomeIcons.shareAlt,
                    altText: AppLocalizations.of(context)!.back,
                    onPressed: () {},
                  ),
                ),
              )
            ],
            flexibleSpace: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: ImageSlider(
                    heroTag: 'HeroTag_${animal.id}',
                    imagesUrls: animal.photos.map((e) => e.reference).toList(),
                  ),
                ),
                Positioned(
                  child: Hero(
                    tag: 'HeroTag_${animal.id}_container',
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                      if (renderLike)
                        BigButton(
                          color: const Color(0xFFEE575F),
                          icon: ref.watch(animalProvider).likedCurrentAnimal ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                          altText: AppLocalizations.of(context)!.likeAnimal(animal.name),
                          onPressed: () => ref.read(animalProvider).updateLikedCurrentAnimal(),
                        )
                    ],
                  ),
                  const SizedBox(height: 27.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimalFeatureCard(
                        mainLabel: animal.sex == 'MALE' ? AppLocalizations.of(context)!.animalSexMale : AppLocalizations.of(context)!.animalSexFemale, //TODO
                        subLabel: AppLocalizations.of(context)!.animalSexLabel,
                      ),
                      AnimalFeatureCard(
                        mainLabel: '${animal.age == 0 ? '>1' : animal.age} ${AppLocalizations.of(context)!.animalYearLabel}',
                        subLabel: AppLocalizations.of(context)!.animalAgeLabel,
                      ),
                      AnimalFeatureCard(
                        mainLabel: '${animal.weight} ${AppLocalizations.of(context)!.weightKgUnit}',
                        subLabel: AppLocalizations.of(context)!.weightLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ShelterInfoCard(
                    imageUrl: animal.shelter.logo.reference,
                    mainLabel: animal.shelter.name,
                    subLabel: '${animal.shelter.city}, ${animal.shelter.country}',
                  ),
                  const DottedDivider(
                    color: Color(0xFF707070),
                  ),
                  Text(animal.description),
                  const SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
