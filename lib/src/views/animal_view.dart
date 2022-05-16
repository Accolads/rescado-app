import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/active_animal.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/services/controllers/active_animal_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/services/providers/device_data.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/backup/misc/dotted_divider.dart';
import 'package:rescado/src/views/buttons/appbar_button.dart';
import 'package:rescado/src/views/buttons/rounded_button.dart';
import 'package:rescado/src/views/containers/list_item.dart';
import 'package:rescado/src/views/misc/animated_logo.dart';
import 'package:rescado/src/views/misc/image_slider.dart';

class AnimalView extends ConsumerWidget {
  static const viewId = 'AnimalView';

  const AnimalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(activeAnimalControllerProvider).when(
        data: (ActiveAnimal activeAnimal) {
          Animal animal = activeAnimal.animal;

          return Scaffold(
            backgroundColor: ref.watch(settingsControllerProvider).activeTheme.backgroundColor, // required for clean Hero animation and bottom overflow on iOS
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: ref.watch(settingsControllerProvider).activeTheme.backgroundColor,
                  stretch: true,
                  pinned: false,
                  expandedHeight: MediaQuery.of(context).size.height / 2,
                  leadingWidth: 66,
                  leading: AppBarButton(
                    semanticsLabel: context.i10n.labelBack,
                    svgAsset: RescadoConstants.iconChevronLeft,
                    opaque: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    AppBarButton(
                      semanticsLabel: context.i10n.labelShare,
                      svgAsset: Platform.isAndroid ? RescadoConstants.iconShareAndroid : RescadoConstants.iconShareiOS,
                      opaque: true,
                      // TODO implement onPressed()
                      onPressed: () => print('NOT IMPLEMENTED'), // ignore: avoid_print
                    )
                  ],
                  flexibleSpace: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: ImageSlider(
                          heroTag: '${RescadoConstants.heroTagPrefix}${animal.id}',
                          imagesUrls: animal.photos.map((image) => image.reference).toList(),
                        ),
                      ),
                      Positioned(
                        child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: ref.watch(settingsControllerProvider).activeTheme.backgroundColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(50),
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
                    color: ref.watch(settingsControllerProvider).activeTheme.backgroundColor,
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
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    animal.breed,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RoundedButton(
                              color: const Color(0xFFEE575F),
                              svgAsset: activeAnimal.isLiked ? RescadoConstants.iconHeartFilled : RescadoConstants.iconHeartOutline,
                              semanticsLabel: context.i10n.labelLike,
                              onPressed: () => ref.read(activeAnimalControllerProvider.notifier).updateActiveAnimal(
                                    animal: animal,
                                    isLiked: !activeAnimal.isLiked,
                                  ),
                            )
                          ],
                        ),
                        const SizedBox(height: 27.0),
                        ListItem(
                          label: animal.shelter.name,
                          subLabel1: '${animal.shelter.city}, ${animal.shelter.country} ${ref.read(deviceDataProvider).getDistance(animal.shelter.coordinates)}',
                          imageUrl: animal.shelter.logo.reference,
                          //TODO is this button needed? + how to handle padding here
                          button: RoundedButton(
                            svgAsset: RescadoConstants.iconInfo,
                            semanticsLabel: context.i10n.labelLike,
                            // TODO implement onPressed()
                            onPressed: () => print('NOT IMPLEMENTED'), // ignore: avoid_print
                          ),
                          // TODO implement onPressed()
                          onPressed: () => print('NOT IMPLEMENTED'), // ignore: avoid_print
                        ),
                        const DottedDivider(
                          color: Color(0xFF707070),
                        ),
                        SafeArea(
                          minimum: const EdgeInsets.only(bottom: 50),
                          child: Text(animal.description),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (_, __) => const Text('error!!'), // TODO Properly handle error scenarios
        loading: () => const Center(
          child: SizedBox(
            width: 50.0,
            child: AnimatedLogo(),
          ),
        ),
      );
}
