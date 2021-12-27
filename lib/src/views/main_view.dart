import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rescado/src/widgets/circle_tab_indicator.dart';

import 'discover_view.dart';
import 'profile_view.dart';
import 'swipe_view.dart';

class MainView extends StatefulWidget {
  static const id = 'MainView';

  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: const SafeArea(
          child: TabBarView(
            children: [DiscoverView(), SwipeView(), ProfileView()],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.red,
          child: SafeArea(
            child: TabBar(
              indicator: CircleTabIndicator(color: Colors.green, radius: 4),
              // padding: const EdgeInsets.symmetric(vertical: 10.0),
              tabs: [
                Tab(
                  icon: SvgPicture.asset(
                    'assets/icons/compass.svg',
                  ),
                ),
                Tab(
                  icon: SvgPicture.asset(
                    'assets/icons/paw.svg',
                  ),
                ),
                Tab(
                  icon: SvgPicture.asset(
                    'assets/icons/user.svg',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
