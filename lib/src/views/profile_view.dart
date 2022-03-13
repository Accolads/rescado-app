import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/services/controllers/like_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/services/providers/device_data.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/buttons/action_button.dart';
import 'package:rescado/src/views/containers/list_item.dart';
import 'package:rescado/src/views/labels/page_title.dart';
import 'package:rescado/src/views/misc/choice_toggle.dart';

class ProfileView extends ConsumerWidget {
  static const viewId = 'ProfileView';
  static const tabIndex = 2;

  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Like> likes = ref.watch(likesControllerProvider).value ?? [];

    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              flexibleSpace: PageTitle(
                label: context.i10n.labelProfile,
              ),
            ),
            SliverAppBar(
              expandedHeight: 260.0,
              floating: true,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) => FlexibleSpaceBar(
                  background: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 55.0,
                        backgroundColor: ref.read(settingsControllerProvider).activeTheme.backgroundVariantColor,
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage('https://media-exp1.licdn.com/dms/image/C4E03AQGIZeIh_ENlHQ/profile-displayphoto-shrink_800_800/0/1584409597470?e=1650499200&v=beta&t=22BuCMtn8D0m61U9aFsZoRlJAi00x7aeJFcj9OuRZys'),
                        ),
                      ),
                      ActionButton(
                        label: 'scoopti doop poop poop',
                        svgAsset: RescadoConstants.iconUsers,
                        onPressed: () {
                          print("hello");
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ChoiceToggle(
                leftOption: 'List',
                rightOption: 'Grid',
                rightActive: true,
                onChanged: (bool active) {
                  print("hey");
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                likes
                    .map((like) => Dismissible(
                          key: ObjectKey(like),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (_) => ref.read(likesControllerProvider.notifier).unlike(like),
                          child: ListItem(
                            label: like.animal.name,
                            subLabel1: '${like.animal.breed}, ${context.i10n.unitYear(like.animal.age)} ${like.animal.sex.toSymbol()}',
                            subLabel2: '${like.animal.shelter.city}, ${like.animal.shelter.country} ${ref.read(deviceDataProvider).getDistance(like.animal.shelter.coordinates)}',
                            imageUrl: like.animal.photos.first.reference,
                            onPressed: () {
                              print("hello");
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
