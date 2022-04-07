import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/data/models/membership.dart';
import 'package:rescado/src/data/models/switch_data.dart';
import 'package:rescado/src/services/controllers/account_controller.dart';
import 'package:rescado/src/services/controllers/like_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/services/controllers/switch_controller.dart';
import 'package:rescado/src/services/providers/device_data.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/buttons/action_button.dart';
import 'package:rescado/src/views/buttons/appbar_button.dart';
import 'package:rescado/src/views/buttons/floating_button.dart';
import 'package:rescado/src/views/containers/list_item.dart';
import 'package:rescado/src/views/labels/page_title.dart';
import 'package:rescado/src/views/misc/animated_logo.dart';
import 'package:rescado/src/views/misc/circle_tab_indicator.dart';
import 'package:rescado/src/views/misc/layout_switch.dart';

import '../data/models/group.dart';

class ProfileView extends ConsumerWidget {
  static const viewId = 'ProfileView';
  static const tabIndex = 2;

  final _headerHeight = 260.0; // Minimum height required for the header to show all its contents

  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    semanticsLabel: context.i10n.labelEdit,
                    svgAsset: RescadoConstants.iconEdit,
                    // opaque: true,
                    onPressed: () => print('NOT IMPLEMENTED'), // ignore: avoid_print
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
                  builder: (_, __) => Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: ref.watch(accountControllerProvider).when(
                                data: (Account account) {
                                  final invitedGroups = account.groups.where((group) => group.status == MembershipStatus.invited);
                                  final confirmedGroup = account.groups.where((group) => group.status == MembershipStatus.confirmed).firstOrNull;
                                  final Iterable<Membership> confirmedGroupMembers = confirmedGroup == null ? [] : confirmedGroup.confirmedMembers.where((member) => member.uuid != account.uuid); // Filter redundant if https://github.com/Rescado/rescado-server/pull/16 is merged

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: <Widget>[
                                          _buildAvatar(
                                            ref: ref,
                                            index: 0,
                                            avatarUrl: account.avatar!.reference,
                                          ),
                                          ..._buildGroupAvatars(
                                            ref: ref,
                                            members: confirmedGroupMembers,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 70.0 + 60.0 * confirmedGroupMembers.length), // last value is "number of avatars - 1"
                                            child: FloatingButton(
                                              semanticsLabel: context.i10n.labelAddFriend,
                                              svgAsset: RescadoConstants.iconUserPlus,
                                              onPressed: () {
                                                print('NOT IMPLEMENTED'); // ignore: avoid_print
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        context.localizeList([account.name ?? context.i10n.labelAnonymous, ...confirmedGroupMembers.map((member) => member.name)]),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      ..._buildInviteButtons(
                                        context: context,
                                        ref: ref,
                                        groups: invitedGroups,
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                    ],
                                  );
                                },
                                error: (_, __) => const Text('error!!'), // TODO Properly handle error scenarios
                                loading: () => const Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    child: AnimatedLogo(),
                                  ),
                                ),
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

  List<Widget> _buildGroupAvatars({required WidgetRef ref, required Iterable<Membership> members}) {
    if (members.isEmpty) {
      return [];
    }

    return members
        .mapIndexed((index, member) => _buildAvatar(
              ref: ref,
              index: index + 1,
              avatarUrl: member.avatar!.reference,
            ))
        .toList();
  }

  List<Widget> _buildInviteButtons({required BuildContext context, required WidgetRef ref, required Iterable<Group> groups}) {
    if (groups.isEmpty) {
      return [];
    }

    return groups
        .map((group) => ActionButton(
              stretched: true,
              label: context.i10n.labelJoin(context.localizeList(group.confirmedMembers.map((member) => member.name).toList())),
              svgAsset: RescadoConstants.iconUsers,
              onPressed: () {
                print('NOT IMPLEMENTED'); // ignore: avoid_print
              },
            ))
        .toList();
  }

  Widget _buildLikesPane() => Consumer(
        builder: (BuildContext context, WidgetRef ref, _) {
          return ref.watch(likesControllerProvider).when(
                data: (List<Like> likes) => CustomScrollView(
                  slivers: <Widget>[
                    const SliverToBoxAdapter(
                      child: LayoutSwitch(),
                    ),
                    if (ref.watch(switchControllerProvider).position == SwitchPosition.left)
                      SliverList(
                        delegate: SliverChildListDelegate(
                          likes
                              .map(
                                (Like like) => Dismissible(
                                  key: ObjectKey(like),
                                  direction: DismissDirection.startToEnd,
                                  onDismissed: (_) => ref.read(likesControllerProvider.notifier).unlike(like),
                                  child: ListItem(
                                    label: like.animal.name,
                                    subLabel1: '${like.animal.breed}, ${context.i10n.unitYear(like.animal.age)} ${like.animal.sex.toSymbol()}',
                                    subLabel2: '${like.animal.shelter.city}, ${like.animal.shelter.country} ${ref.read(deviceDataProvider).getDistance(like.animal.shelter.coordinates)}',
                                    imageUrl: like.animal.photos.first.reference,
                                    onPressed: () {
                                      print('NOT IMPLEMENTED'); // ignore: avoid_print
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
                error: (_, __) => const Text('error!!'), // TODO Handle error scenarios properly
                loading: () => const Center(
                  child: SizedBox(
                    width: 50.0,
                    child: AnimatedLogo(),
                  ),
                ),
              );
        },
      );

  // TODO write the code for this pane
  Widget _buildMatchesPane() => Container(
        color: Colors.blue,
        child: const Text('Hello matches'),
      );
}
