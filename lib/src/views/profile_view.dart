import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/user.dart';
import 'package:rescado/src/services/controllers/like_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/services/controllers/user_controller.dart';
import 'package:rescado/src/views/authentication_view.dart';
import 'package:rescado/src/views/buttons/action_button.dart';
import 'package:rescado/src/views/labels/page_title.dart';
import 'package:rescado/src/views/misc/circle_tab_indicator.dart';
import 'package:rescado/src/views/swipe_view.dart';

import 'containers/action_card.dart';

// Placeholder view.
class ProfileView extends ConsumerStatefulWidget {
  static const viewId = 'ProfileView';

  const ProfileView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  void _deleteLike(int index) {
    print("delete");
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userControllerProvider).value!; //TODO should this happen in constructor?
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              floating: false,
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height / 2.3, // temporary
              collapsedHeight: user.status == UserStatus.identified ? MediaQuery.of(context).size.height / 3.3 : MediaQuery.of(context).size.height / 2.3,
              flexibleSpace: Column(
                children: [
                  PageTitle(
                    label: AppLocalizations.of(context)!.labelProfile,
                  ),
                  _buildUserStatus(user),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: ref.watch(settingsControllerProvider).activeTheme.borderColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: DefaultTabController(
                      length: 2,
                      child: TabBar(
                        indicator: CircleTabIndicator(
                          color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
                        ),
                        tabs: const [
                          Tab(text: 'Likes'),
                          Tab(text: 'Matches'),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          _buildLikes()
        ],
      ),
    );
  }

  Widget _buildUserStatus(User user) {
    switch (user.status) {
      case UserStatus.identified:
        return const CircleAvatar(
          //TODO
          backgroundImage: NetworkImage('https://images.news18.com/ibnlive/uploads/2021/08/donald-trump-comments-on-the-taliban-16293574924x3.jpg'),
          radius: 50.0,
        );
      default:
        return ActionCard(
          title: "Je bent niet aangemeld!",
          body: "Je kan Rescado anoniem gebruiken, maar een account laat je toe je likes te synchroniseren tussen al je toestellen, in groep te swipen en meer!",
          animated: true,
          svgAsset: RescadoConstants.illustrationWomanOnChairWithPhone,
          actionButton: ActionButton(
            label: 'Aanmelden',
            svgAsset: RescadoConstants.iconKey,
            onPressed: () => Navigator.pushNamed(context, AuthenticationView.viewId),
          ),
        );
    }
  }

  Widget _buildLikes() {
    var likes = ref.watch(likeControllerProvider).value;
    if (likes == null || likes.isNotEmpty) {
      return SliverFillRemaining(child: _buildEmptyLikes());
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            var like = likes[index];
            return Dismissible(
              key: ObjectKey(like),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) => _deleteLike(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 16.0,
                ),
                child: _buildTile(like.animal),
              ),
            );
          },
          childCount: likes.length,
        ),
      );
    }
  }

  Widget _buildTile(Animal animal) {
    return Card(
      margin: EdgeInsets.zero,
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

  Widget _buildEmptyLikes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Eens je dieren geliket hebt, kan je hier een overzichtje terugvinden. Maar het ziet ernaar uit dat je nog geen hartjes uitgedeeld hebt!'),
          const SizedBox(
            height: 26.0,
          ),
          ActionButton(
            label: 'Swipe time',
            svgAsset: RescadoConstants.iconHeartOutline,
            onPressed: () => Navigator.pushNamed(context, SwipeView.viewId),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(RescadoConstants.illustrationWomanHoldingPhoneWithHearts),
          )
        ],
      ),
    );
  }
}
