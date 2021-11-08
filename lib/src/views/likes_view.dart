import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/services/like_service.dart';
import 'package:rescado/src/styles/rescado_style.dart';
import 'package:rescado/src/views/animal_detail_view.dart';

// Placeholder view. Will be completely replaced when implemented.
class LikesView extends StatefulWidget {
  static const id = 'LikesView';

  const LikesView({Key? key}) : super(key: key);

  @override
  State<LikesView> createState() => _LikesViewState();
}

class _LikesViewState extends State<LikesView> {
  List<AnimalModel> animals = [];

  @override
  void initState() {
    LikeService.getLikedAnimals().then((a) {
      setState(() => animals.addAll(a));
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
          AppLocalizations.of(context)!.likeViewTitle,
          style: RescadoStyle.viewTitle(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 36,
          right: 20,
          left: 20.0,
        ),
        child: animals.isNotEmpty
            ? ListView.builder(
                itemCount: animals.length,
                itemBuilder: (_, index) {
                  AnimalModel animal = animals[index];
                  NetworkImage image = NetworkImage(animal.photos.first.reference);
                  precacheImage(image, context);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<AnimalDetailView>(
                          builder: (context) => AnimalDetailView(
                            animal: animal,
                            renderLike: false,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Hero(
                              tag: 'HeroTag_${animal.id}',
                              child: CircleAvatar(
                                radius: 32.0,
                                backgroundImage: image,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                animal.name,
                                style: RescadoStyle.viewTitle(context),
                              ),
                              Text(
                                animal.breed,
                                style: RescadoStyle.cardSubTitle(context),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(child: Text('Geen doggos')),
      ),
    );
  }
}
