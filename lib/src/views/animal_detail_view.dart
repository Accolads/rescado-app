import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/styles/rescado_style.dart';
import 'package:rescado/src/widgets/animal_feature_card.dart';
import 'package:rescado/src/widgets/big_button.dart';
import 'package:rescado/src/widgets/dotted_divider.dart';
import 'package:rescado/src/widgets/image_slider.dart';
import 'package:rescado/src/widgets/shelter_info_card.dart';

class AnimalDetailView extends StatefulWidget {
  static const id = 'AnimalDetailView';

  final AnimalModel animal;
  final Function? onLike;

  const AnimalDetailView({required this.animal, this.onLike, Key? key}) : super(key: key);

  @override
  State<AnimalDetailView> createState() => _AnimalDetailViewState();
}

class _AnimalDetailViewState extends State<AnimalDetailView> {
  bool _liked = false;

  void toggleLike() => setState(() => _liked = !_liked);

  void onReturn() {
    Navigator.pop(context);
    if (_liked) widget.onLike!();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => onReturn(),
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
                    heroTag: 'HeroTag_${widget.animal.id}',
                    imagesUrls: widget.animal.photos.map((e) => e.reference).toList(),
                  ),
                ),
                Positioned(
                  child: Hero(
                    tag: 'HeroTag_${widget.animal.id}_container',
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
                              widget.animal.name,
                              style: RescadoStyle.cardTitle(context),
                            ),
                            Text(
                              widget.animal.breed,
                              style: RescadoStyle.cardSubTitle(context),
                            ),
                          ],
                        ),
                      ),
                      if (widget.onLike != null)
                        BigButton(
                          color: const Color(0xFFEE575F),
                          icon: _liked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                          altText: AppLocalizations.of(context)!.likeAnimal(widget.animal.name),
                          onPressed: toggleLike,
                        ),
                    ],
                  ),
                  const SizedBox(height: 27.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimalFeatureCard(
                        mainLabel: widget.animal.sex == 'MALE' ? AppLocalizations.of(context)!.animalSexMale : AppLocalizations.of(context)!.animalSexFemale, //TODO
                        subLabel: AppLocalizations.of(context)!.animalSexLabel,
                      ),
                      AnimalFeatureCard(
                        mainLabel: '${widget.animal.age == 0 ? '>1' : widget.animal.age} ${AppLocalizations.of(context)!.animalYearLabel}',
                        subLabel: AppLocalizations.of(context)!.animalAgeLabel,
                      ),
                      AnimalFeatureCard(
                        mainLabel: '${widget.animal.weight} ${AppLocalizations.of(context)!.weightKgUnit}',
                        subLabel: AppLocalizations.of(context)!.weightLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ShelterInfoCard(
                    imageUrl: widget.animal.shelter.logo.reference,
                    mainLabel: widget.animal.shelter.name,
                    subLabel: '${widget.animal.shelter.city}, ${widget.animal.shelter.country}',
                  ),
                  const DottedDivider(
                    color: Color(0xFF707070),
                  ),
                  Text(widget.animal.description),
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
