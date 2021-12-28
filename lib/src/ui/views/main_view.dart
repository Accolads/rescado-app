import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rescado/src/ui/styles/rescado_style.dart';
import 'package:rescado/src/ui/misc/circle_tab_indicator.dart';
import 'package:rescado/src/ui/views/discover/discover_view.dart';
import 'package:rescado/src/ui/views/profile/profile_view.dart';
import 'package:rescado/src/ui/views/swipe/swipe_view.dart';
import 'package:rescado/src/util/logger.dart';

class MainView extends StatefulWidget {
  static const id = 'MainView';
  final logger = getLogger(id);

  MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _tabIndex = 0;

  Tab _buildTab(String svgAsset, bool active) {
    return Tab(
      icon: SvgPicture.asset(
        svgAsset,
        color: active ? Theme.of(context).tabBarTheme.labelColor : Theme.of(context).tabBarTheme.unselectedLabelColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.logger.d('build()');
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
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
                _buildTab(
                  RescadoStyle.iconCompass,
                  _tabIndex == 0,
                ),
                _buildTab(
                  RescadoStyle.iconLogo,
                  _tabIndex == 1,
                ),
                _buildTab(
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
}
