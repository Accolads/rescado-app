import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/services/controllers/like_controller.dart';
import 'package:rescado/src/services/controllers/main_tab_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/buttons/action_button.dart';
import 'package:rescado/src/views/buttons/floating_button.dart';
import 'package:rescado/src/views/labels/page_title.dart';
import 'package:rescado/src/views/misc/choice_toggle.dart';
import 'package:rescado/src/views/misc/circle_tab_indicator.dart';
import 'package:rescado/src/views/misc/interactive_grid_tile.dart';
import 'package:rescado/src/views/swipe_view.dart';

class ProfileView extends ConsumerStatefulWidget {
  static const viewId = 'ProfileView';
  static const tabIndex = 2;

  const ProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool renderGrid = false;
  bool canCollapse = false;

  void onLayoutToggleChange(bool active) => setState(() => renderGrid = active);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, _) =>
          [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: height / 2.4,
                collapsedHeight: canCollapse ? (height / 4) + 60 : height / 2.4,
                flexibleSpace: Column(
                  children: [
                    PageTitle(
                      label: context.i10n.labelProfile,
                    ),
                    _buildUserStatus(),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ActionButton(
                            label: "Vorm een groep met Ella, Jan en Hans!",
                            svgAsset: RescadoConstants.iconUsers,
                            onPressed: () => print('ool'),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: ref
                                .watch(settingsControllerProvider)
                                .activeTheme
                                .borderColor,
                          ),
                        ),
                      ),
                      child: TabBar(
                        indicator: CircleTabIndicator(
                          color: ref
                              .watch(settingsControllerProvider)
                              .activeTheme
                              .accentColor,
                        ),
                        tabs: const [
                          Tab(child: Text('Like')),
                          Tab(child: Text('Matches')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _buildLikeTab(),
              _buildMatchTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLikeTab() {
    return ref.watch(likeControllerProvider).when(
      data: (List<Like> likes) {
        if (likes.isEmpty) {
          setState(() => canCollapse = false);
          return _buildPlaceholder(
            'Eens je dieren geliket hebt, kan je hier een overzichtje terugvinden. Maar het ziet ernaar uit dat je nog geen hartjes uitgedeeld hebt!',
            ActionButton(
              label: 'Swipe time',
              svgAsset: RescadoConstants.iconHeartOutline,
              onPressed: () => ref.watch(tabControllerProvider.notifier).setActiveTab(SwipeView.tabIndex),
            ),
            RescadoConstants.illustrationWomanHoldingPhoneWithHearts,
          );
        } else {
          setState(() => canCollapse = true);
          return RefreshIndicator(
            color: ref
                .watch(settingsControllerProvider)
                .activeTheme
                .accentColor,
            displacement: MediaQuery
                .of(context)
                .size
                .height / 2.3,
            onRefresh: () async {
              await ref.read(likeControllerProvider.notifier).fetchLikes();
            },
            child: Builder(
              builder: (context) {
                return CustomScrollView(
                  key: const PageStorageKey<String>('Like'),
                  slivers: [
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    SliverToBoxAdapter(
                      child: ChoiceToggle(
                        leftOption: 'List',
                        rightOption: 'Grid',
                        rightActive: renderGrid,
                        onChanged: onLayoutToggleChange,
                      ),
                    ),
                    if (!renderGrid)
                      SliverList(
                        delegate: SliverChildListDelegate(
                          likes
                              .map((like) =>
                              Dismissible(
                                key: ObjectKey(like),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (_) => ref.read(likeControllerProvider.notifier).deleteLike(like),
                                child: _buildTile(like.animal),
                              ))
                              .toList(),
                        ),
                      ),
                    if (renderGrid)
                      SliverGrid(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150.0,
                          mainAxisSpacing: 1.0,
                          crossAxisSpacing: 1.0,
                        ),
                        delegate: SliverChildListDelegate(
                          likes
                              .map((like) =>
                              InteractiveGridTile(
                                key: ObjectKey(like),
                                image: like.animal.photos.first.reference,
                                floatingButton: FloatingButton(
                                  onPressed: () => ref.read(likeControllerProvider.notifier).deleteLike(like),
                                  svgAsset: RescadoConstants.iconHeartBroken,
                                  semanticsLabel: context.i10n.labelUnlike,
                                ),
                              ))
                              .toList(),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        }
      },
      // TODO properly implement error
      error: (_, __) => const Text('error!!'),
      loading: () => Container(),
    );
  }

  //TODO
  Widget _buildMatchTab() {
    return Builder(
        builder: (context) {
          return CustomScrollView(
          key: const PageStorageKey<String>('Match'),
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverFillRemaining(
                child: _buildPlaceholder(
                  'Jullie hebben nog geen gemeenschappelijke likes binnen jullie groep. Stel jullie filters wat op elkaar af en swipe nog meer om jullie kans op matches te verhogen!',
                  ActionButton(
                    label: 'Swipe time',
                    svgAsset: RescadoConstants.iconHeartOutline,
                    onPressed: () => ref.watch(tabControllerProvider.notifier).setActiveTab(SwipeView.tabIndex),
                  ),
                  RescadoConstants.illustrationPeopleSittingOnCouch,
                ),
              ),
            ],
          );
        }
    );
  }

  Widget _buildUserStatus() {
    return const CircleAvatar(
      //TODO
      backgroundImage: NetworkImage('https://media-exp1.licdn.com/dms/image/C4E03AQGIZeIh_ENlHQ/profile-displayphoto-shrink_800_800/0/1584409597470?e=1650499200&v=beta&t=22BuCMtn8D0m61U9aFsZoRlJAi00x7aeJFcj9OuRZys'),
      radius: 50.0,
    );
  }

  Widget _buildTile(Animal animal) {
    return Card(
      key: ObjectKey(animal),
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 16.0,
      ),
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        tileColor: ref
            .watch(settingsControllerProvider)
            .activeTheme
            .accentColor
            .withOpacity(0.20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        leading: CircleAvatar(
          radius: 32.0,
          backgroundImage: NetworkImage(animal.photos.first.reference),
        ),
        title: Text(
          animal.name,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${animal.breed}, ${animal.birthday?.toAgeString()}',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            Text(
              '${animal.shelter.city}, ${animal.shelter.country}',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String text, ActionButton actionButton, String asset) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(text),
              const SizedBox(
                height: 26.0,
              ),
              SizedBox(
                width: 160,
                child: actionButton,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SvgPicture.asset(asset),
              )
            ],
          ),
        ],
      ),
    );
  }
}
