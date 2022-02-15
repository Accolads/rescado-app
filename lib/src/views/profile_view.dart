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
import 'package:rescado/src/views/labels/page_title.dart';
import 'package:rescado/src/views/misc/choice_toggle.dart';
import 'package:rescado/src/views/misc/circle_tab_indicator.dart';
import 'package:rescado/src/views/swipe_view.dart';

class ProfileView extends ConsumerStatefulWidget {
  static const viewId = 'ProfileView';
  static const tabIndex = 2;

  const ProfileView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool renderGrid = false;
  bool canCollapse = false;

  void onLayoutToggleChange(bool active) => setState(() => renderGrid = active);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, _) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: true,
                expandedHeight: height / 2.4,
                collapsedHeight: canCollapse ? height / 4 : height / 2.8, //TODO
                flexibleSpace: Column(
                  children: [
                    PageTitle(
                      label: context.i10n.labelProfile,
                    ),
                    _buildUserStatus(),
                  ],
                ),
                bottom: TabBar(
                  indicator: CircleTabIndicator(
                    color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
                  ),
                  tabs: const [
                    Tab(child: Text('Like')),
                    Tab(child: Text('Matches')),
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
            setState(() => canCollapse = false);
            if (likes.isEmpty) {
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
                color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
                displacement: MediaQuery.of(context).size.height / 2.3,
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
                            leftChoice: 'List',
                            rightChoice: 'Grid',
                            rightActive: renderGrid,
                            onChanged: onLayoutToggleChange,
                          ),
                        ),
                        if (!renderGrid)
                          SliverList(
                            delegate: SliverChildListDelegate(
                              likes
                                  .map((like) => Dismissible(
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
                            delegate: SliverChildBuilderDelegate(
                              (_, int index) {
                                //TODO buildSquare
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(likes[index].animal.photos.first.reference),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              childCount: likes.length,
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
    setState(() => canCollapse = false);
    return _buildPlaceholder(
        'Jullie hebben nog geen gemeenschappelijke likes binnen jullie groep. Stel jullie filters wat op elkaar af en swipe nog meer om jullie kans op matches te verhogen!',
        ActionButton(
          label: 'Swipe time',
          svgAsset: RescadoConstants.iconHeartOutline,
          onPressed: () => ref.watch(tabControllerProvider.notifier).setActiveTab(SwipeView.tabIndex),
        ),
        RescadoConstants.illustrationPeopleSittingOnCouch,
      );
  }

  Widget _buildUserStatus() {
    return const CircleAvatar(
      //TODO
      backgroundImage: NetworkImage('https://images.news18.com/ibnlive/uploads/2021/08/donald-trump-comments-on-the-taliban-16293574924x3.jpg'),
      radius: 50.0,
    );
  }

  Widget _buildTile(Animal animal) {
    return Card(
      key: UniqueKey(),
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 16.0,
      ),
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        tileColor: ref.watch(settingsControllerProvider).activeTheme.accentColor.withOpacity(0.20),
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
              '${animal.breed}, 2y',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            const Text(
              'Genk, België (69 km)',
              style: TextStyle(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(text),
          const SizedBox(
            height: 26.0,
          ),
          actionButton,
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(asset),
          )
        ],
      ),
    );
  }
}
