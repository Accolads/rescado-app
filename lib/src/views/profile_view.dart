import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/services/controllers/like_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/services/providers/device_data.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/buttons/action_button.dart';
import 'package:rescado/src/views/buttons/appbar_button.dart';
import 'package:rescado/src/views/buttons/floating_button.dart';
import 'package:rescado/src/views/containers/list_item.dart';
import 'package:rescado/src/views/labels/page_title.dart';
import 'package:rescado/src/views/misc/animated_logo.dart';
import 'package:rescado/src/views/misc/layout_switch.dart';
import 'package:rescado/src/views/misc/circle_tab_indicator.dart';

class ProfileView extends ConsumerWidget {
  static const viewId = 'ProfileView';
  static const tabIndex = 2;

  final _headerHeight = 260.0; // Minimum height required for the header to show all its contents

  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO Should use Consumer inside StatelessWidget so we can build something temporarily while data is being fetched.
    // Data to be fetched here = profile and group data

    final preferredHeight = MediaQuery.of(context).size.height / 3;
    final actualHeight = preferredHeight < _headerHeight ? _headerHeight : preferredHeight;

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scrollbar(
          child: NestedScrollView(
            headerSliverBuilder: (_, __) => <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                actions: <Widget>[
                  AppBarButton(
                    semanticsLabel: 'hello',
                    svgAsset: RescadoConstants.iconEdit,
                    // opaque: true,
                    onPressed: () => {print('edit')}, // ignore: avoid_print
                  ),
                ],
                flexibleSpace: PageTitle(
                  label: context.i10n.labelProfile,
                ),
              ),
              SliverAppBar(
                pinned: true,
                toolbarHeight: 7.5,
                // Indicator radius
                expandedHeight: actualHeight,
                flexibleSpace: LayoutBuilder(
                  // TODO Use this builder to add effects on scroll (eg scale profile images)
                  builder: (context, constraints) => Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.bottomLeft,
                                children: <Widget>[
                                  _buildAvatar(
                                    ref: ref,
                                    index: 0,
                                    avatarUrl: 'https://i.pravatar.cc/500',
                                  ),
                                  _buildAvatar(
                                    ref: ref,
                                    index: 1,
                                    avatarUrl: 'https://i.pravatar.cc/501',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 70.0 + 60.0 * 1), // last int is avatar array size - 1
                                    child: FloatingButton(
                                      semanticsLabel: 'yow',
                                      svgAsset: RescadoConstants.iconUserPlus,
                                      onPressed: () {
                                        print('yeeee'); // ignore: avoid_print
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const Text(
                                'Grietje en Hans',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              // TODO preceed with if: only show if an invite is pending
                              ActionButton(
                                stretched: true,
                                label: 'scoopti doop poop poop',
                                svgAsset: RescadoConstants.iconUsers,
                                onPressed: () {
                                  print('hello'); // ignore: avoid_print
                                },
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        // Tab bar background
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: ref.watch(settingsControllerProvider).activeTheme.backgroundColor,
                          border: Border(
                            bottom: BorderSide(
                              color: ref.watch(settingsControllerProvider).activeTheme.borderColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                  indicator: CircleTabIndicator(
                    color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
                  ),
                  tabs: [
                    Tab(
                      text: context.i10n.labelLikes,
                    ),
                    Tab(
                      text: context.i10n.labelMatches,
                    ),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildLikesPane(),
                _buildMatchesPane(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar({required WidgetRef ref, required int index, required String avatarUrl}) {
    double size = index == 0 ? 45.0 : 34.0;
    double padding = index == 0 ? 15.0 : 30.0 + index * size * 1.6;

    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: CircleAvatar(
        radius: size + 5.0,
        backgroundColor: ref.read(settingsControllerProvider).activeTheme.backgroundVariantColor,
        child: CircleAvatar(
          radius: size,
          backgroundImage: NetworkImage(avatarUrl),
        ),
      ),
    );
  }

  Widget _buildLikesPane() => Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return ref.watch(likesControllerProvider).when(
                data: (likes) => CustomScrollView(
                  slivers: <Widget>[
                    const SliverToBoxAdapter(
                      child: LayoutSwitch(),
                    ),
                    // Generate the list of likes
                    SliverList(
                      delegate: SliverChildListDelegate(
                        likes
                            .map(
                              (like) => Dismissible(
                                key: ObjectKey(like),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (_) => ref.read(likesControllerProvider.notifier).unlike(like),
                                child: ListItem(
                                  label: like.animal.name,
                                  subLabel1: '${like.animal.breed}, ${context.i10n.unitYear(like.animal.age)} ${like.animal.sex.toSymbol()}',
                                  subLabel2: '${like.animal.shelter.city}, ${like.animal.shelter.country} ${ref.read(deviceDataProvider).getDistance(like.animal.shelter.coordinates)}',
                                  imageUrl: like.animal.photos.first.reference,
                                  onPressed: () {
                                    print('hello'); // ignore: avoid_print
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    // Some clean spacing at the bottom of the list
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 25.0,
                      ),
                    ),
                  ],
                ),
                error: (_, __) => const Text('error!!'),
                loading: () => const Center(
                  child: SizedBox(
                    width: 50.0,
                    child: AnimatedLogo(),
                  ),
                ),
              );
        },
      );

  Widget _buildMatchesPane() => Container(
        color: Colors.blue,
        child: const Text('Hello matches'),
      );
}
