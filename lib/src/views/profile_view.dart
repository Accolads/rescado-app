import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/data/models/membership.dart';
import 'package:rescado/src/data/models/switch_data.dart';
import 'package:rescado/src/services/controllers/account_controller.dart';
import 'package:rescado/src/services/controllers/like_controller.dart';
import 'package:rescado/src/services/controllers/main_tab_controller.dart';
import 'package:rescado/src/services/controllers/match_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/services/controllers/switch_controller.dart';
import 'package:rescado/src/services/providers/device_data.dart';
import 'package:rescado/src/utils/custom_clamping_scroll_physics.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/buttons/action_button.dart';
import 'package:rescado/src/views/buttons/appbar_button.dart';
import 'package:rescado/src/views/buttons/rounded_button.dart';
import 'package:rescado/src/views/containers/grid_item.dart';
import 'package:rescado/src/views/containers/list_item.dart';
import 'package:rescado/src/views/labels/page_title.dart';
import 'package:rescado/src/views/misc/animated_logo.dart';
import 'package:rescado/src/views/misc/circle_tab_indicator.dart';
import 'package:rescado/src/views/misc/layout_switch.dart';
import 'package:rescado/src/views/swipe_view.dart';

import '../data/models/group.dart';

class ProfileView extends ConsumerWidget {
  static const viewId = 'ProfileView';
  static const tabIndex = 2;

  final _headerHeight = 260.0; // Minimum height required for the header to show all its contents

  const ProfileView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferredHeight = MediaQuery.of(context).size.height / 3;
    final actualHeight = preferredHeight < _headerHeight ? _headerHeight : preferredHeight;

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scrollbar(
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (_, __) => <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                actions: <Widget>[
                  AppBarButton(
                    semanticsLabel: context.i10n.labelEdit,
                    svgAsset: RescadoConstants.iconEdit,
                    // TODO implement onPressed()
                    onPressed: () => print('NOT IMPLEMENTED'), // ignore: avoid_print
                  ),
                ],
                flexibleSpace: PageTitle(
                  label: context.i10n.labelProfile,
                ),
              ),
              SliverAppBar(
                pinned: true,
                toolbarHeight: 7.5 /* Indicator radius */,
                expandedHeight: actualHeight,
                flexibleSpace: LayoutBuilder(
                  builder: (_, BoxConstraints constraints) => Stack(
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
                                  final confirmedGroupConfirmedMembers = confirmedGroup?.confirmedMembers ?? [];

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Opacity(
                                        opacity: constraints.maxHeight / actualHeight,
                                        child: Transform.scale(
                                          scale: constraints.maxHeight / actualHeight,
                                          child: Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: <Widget>[
                                              _buildAvatar(
                                                ref: ref,
                                                index: 0,
                                                avatarUrl: account.avatar?.reference,
                                              ),
                                              ..._buildGroupAvatars(
                                                ref: ref,
                                                members: confirmedGroupConfirmedMembers,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 70.0 + 60.0 * confirmedGroupConfirmedMembers.length), // last value is "number of avatars - 1"
                                                child: RoundedButton(
                                                  semanticsLabel: context.i10n.labelAddFriend,
                                                  svgAsset: RescadoConstants.iconUserPlus,
                                                  // TODO implement onPressed()
                                                  onPressed: () => print('NOT IMPLEMENTED'), // ignore: avoid_print
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        context.localizeList([account.name ?? context.i10n.labelAnonymous, ...confirmedGroupConfirmedMembers.map((member) => member.name)]),
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
                _buildLikesPane(
                  context: context,
                  ref: ref,
                ),
                _buildMatchesPane(
                  context: context,
                  ref: ref,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar({required WidgetRef ref, required int index, required String? avatarUrl}) {
    double size = index == 0 ? 45.0 : 34.0;
    double padding = index == 0 ? 15.0 : 30.0 + index * size * 1.6;

    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: CircleAvatar(
        radius: size + 5.0,
        backgroundColor: ref.read(settingsControllerProvider).activeTheme.backgroundVariantColor,
        child: CircleAvatar(
          radius: size,
          foregroundColor: ref.watch(settingsControllerProvider).activeTheme.primaryDimmedColor,
          foregroundImage: avatarUrl == null ? null : NetworkImage(avatarUrl),
          backgroundImage: AssetImage(RescadoConstants.imageDefaultProfilePicture),
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
              avatarUrl: member.avatar?.reference,
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
              // TODO implement onPressed()
              onPressed: () => print('NOT IMPLEMENTED'), // ignore: avoid_print
            ))
        .toList();
  }

  Widget _buildLikesPane({required BuildContext context, required WidgetRef ref}) => ref.watch(likeControllerProvider).when(
        data: (List<Like> likes) {
          return CustomScrollView(
            physics: Platform.isAndroid ? const CustomClampingScrollPhysics(canUnderscroll: true) : const BouncingScrollPhysics(),
            slivers: <Widget>[
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await Future<dynamic>.delayed(const Duration(milliseconds: 1111));
                  await ref.read(likeControllerProvider.notifier).fetchLikes();
                },
                builder: _buildRefreshIndicator(),
              ),
              if (likes.isEmpty)
                ..._buildPlaceholder(
                  label: context.i10n.messageEmptyLikes,
                  actionButton: ActionButton(
                    label: context.i10n.labelSwipeTime,
                    onPressed: () => ref.watch(tabControllerProvider.notifier).setActiveTab(SwipeView.tabIndex),
                    svgAsset: RescadoConstants.iconHeartOutline,
                  ),
                  asset: RescadoConstants.illustrationWomanHoldingPhoneWithHearts,
                )
              else
                ..._buildLikesList(
                  context: context,
                  ref: ref,
                  likes: likes,
                )
            ],
          );
        },
        error: (_, __) => const Text('error!!'), // TODO Handle error scenarios properly
        loading: () => const Center(
          child: SizedBox(
            width: 50.0,
            child: AnimatedLogo(),
          ),
        ),
      );

  Widget _buildMatchesPane({required BuildContext context, required WidgetRef ref}) => ref.read(accountControllerProvider).when(
        data: (Account account) {
          final confirmedGroup = account.groups.where((group) => group.status == MembershipStatus.confirmed).firstOrNull;
          if (confirmedGroup == null) {
            return CustomScrollView(
              slivers: _buildPlaceholder(
                label: context.i10n.messageNoGroup,
                actionButton: ActionButton(
                  label: context.i10n.labelCreateGroup,
                  onPressed: () => ref.watch(tabControllerProvider.notifier).setActiveTab(SwipeView.tabIndex),
                  svgAsset: RescadoConstants.iconUsers,
                ),
                asset: RescadoConstants.illustrationTinyPeopleBigPhones,
              ),
            );
          } else {
            return ref.watch(matchControllerProvider).when(
                  data: (List<Like> likes) {
                    return CustomScrollView(
                      physics: Platform.isAndroid ? const CustomClampingScrollPhysics(canUnderscroll: true) : const BouncingScrollPhysics(),
                      slivers: <Widget>[
                        CupertinoSliverRefreshControl(
                            onRefresh: () async {
                              await Future<dynamic>.delayed(const Duration(milliseconds: 1111));
                              await ref.read(matchControllerProvider.notifier).fetchMatches();
                            },
                            builder: _buildRefreshIndicator()),
                        if (likes.isEmpty)
                          ..._buildPlaceholder(
                            label: context.i10n.messageNoMatches,
                            actionButton: ActionButton(
                              label: context.i10n.labelSwipeTime,
                              onPressed: () => ref.watch(tabControllerProvider.notifier).setActiveTab(SwipeView.tabIndex),
                              svgAsset: RescadoConstants.iconHeartOutline,
                            ),
                            asset: RescadoConstants.illustrationPeopleSittingOnCouch,
                          )
                        else
                          ..._buildLikesList(
                            context: context,
                            ref: ref,
                            likes: likes,
                          )
                      ],
                    );
                  },
                  error: (_, __) => const Text('error!!'), // TODO Handle error scenarios properly
                  loading: () => const Center(
                    child: SizedBox(
                      width: 50.0,
                      child: AnimatedLogo(
                        play: true,
                      ),
                    ),
                  ),
                );
          }
        },
        error: (_, __) => const Text('error!!'), // TODO Properly handle error scenarios
        loading: () => const Center(
          child: SizedBox(
            width: 50.0,
            child: AnimatedLogo(),
          ),
        ),
      );

  List<Widget> _buildLikesList({required BuildContext context, required WidgetRef ref, required List<Like> likes}) => <Widget>[
        const SliverAppBar(
          pinned: true,
          floating: true,
          snap: true,
          flexibleSpace: LayoutSwitch(),
        ),
        if (ref.watch(switchControllerProvider).position == SwitchPosition.left)
          SliverList(
            delegate: SliverChildListDelegate(
              likes
                  .map(
                    (Like like) => Dismissible(
                      key: ObjectKey(like),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (_) => ref.read(likeControllerProvider.notifier).unlike(like),
                      child: ListItem(
                        label: like.animal.name,
                        subLabel1: '${like.animal.breed}, ${context.i10n.unitYear(like.animal.age)} ${like.animal.sex.toSymbol()}',
                        subLabel2: '${like.animal.shelter.city}, ${like.animal.shelter.country} ${ref.read(deviceDataProvider).getDistance(like.animal.shelter.coordinates)}',
                        imageUrl: like.animal.photos.first.reference,
                        // TODO implement onPressed()
                        onPressed: () => print('NOT IMPLEMENTED'), // ignore: avoid_print
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        if (ref.watch(switchControllerProvider).position == SwitchPosition.right)
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
            ),
            delegate: SliverChildListDelegate(
              likes
                  .map((Like like) => GridItem(
                        key: ObjectKey(like),
                        image: like.animal.photos.first.reference,
                        roundedButton: RoundedButton(
                          onPressed: () => ref.read(likeControllerProvider.notifier).unlike(like),
                          svgAsset: RescadoConstants.iconHeartBroken,
                          semanticsLabel: context.i10n.labelUnlike,
                        ),
                      ))
                  .toList(),
            ),
          ),
        // Some clean spacing at the bottom of the list
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 25.0,
          ),
        ),
      ];

  RefreshControlIndicatorBuilder _buildRefreshIndicator() => (_, RefreshIndicatorMode refreshIndicatorMode, ___, ____, _____) {
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            width: 40.0,
            child: AnimatedLogo(
              play: refreshIndicatorMode == RefreshIndicatorMode.refresh,
            ),
          ),
        );
      };

  List<Widget> _buildPlaceholder({required String label, required ActionButton actionButton, required String asset}) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0, right: 30.0, bottom: 10.0, left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label),
                const SizedBox(height: 30.0),
                actionButton,
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          fillOverscroll: true,
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(
              asset,
              width: 220.0,
            ),
          ),
        ),
      ];
}
