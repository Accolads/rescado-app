import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rescado/src/styles/rescado_style.dart';
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
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: const SafeArea(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [DiscoverView(), SwipeView(), ProfileView()],
          ),
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: TabBar(
              indicator: CircleTabIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              onTap: (value) => setState(() {
                _tabIndex = value;
              }),
              tabs: [
                buildTab(
                  RescadoStyle.iconCompass,
                  _tabIndex == 0,
                ),
                buildTab(
                  RescadoStyle.iconLogo,
                  _tabIndex == 1,
                ),
                buildTab(
                  RescadoStyle.iconUser,
                  _tabIndex == 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTab(String svgAsset, bool active) {
    return Tab(
      icon: SvgPicture.asset(
        svgAsset,
        color: active ? Theme.of(context).tabBarTheme.labelColor : Theme.of(context).tabBarTheme.unselectedLabelColor,
      ),
    );
  }
}
