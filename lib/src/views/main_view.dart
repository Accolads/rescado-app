import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/views/discover_view.dart';
import 'package:rescado/src/views/misc/circle_tab_indicator.dart';
import 'package:rescado/src/views/misc/simple_tooltip.dart';
import 'package:rescado/src/views/profile_view.dart';
import 'package:rescado/src/views/swipe_view.dart';

// Main view of the application. What a logged in user sees and uses to navigate through the app..
class MainView extends StatefulWidget {
  static const viewId = 'MainView';

  const MainView({
    Key? key,
  }) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _activeTab = 1;

  final _tabData = [
    _MainViewTabData(
      svgAsset: RescadoConstants.iconCompass,
      label: (BuildContext context) => AppLocalizations.of(context)!.labelDiscover,
      view: const DiscoverView(),
    ),
    _MainViewTabData(
      svgAsset: RescadoConstants.iconLogo,
      label: (BuildContext context) => AppLocalizations.of(context)!.labelSwipe,
      view: const SwipeView(),
    ),
    _MainViewTabData(
      svgAsset: RescadoConstants.iconUser,
      label: (BuildContext context) => AppLocalizations.of(context)!.labelProfile,
      view: const ProfileView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _activeTab,
      length: _tabData.length,
      child: Scaffold(
        body: SafeArea(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: _tabData.map((data) => data.toView()).toList(),
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
                _activeTab = value;
              }),
              tabs: _tabData.asMap().entries.map((data) => data.value.toTab(context, data.key == _activeTab)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainViewTabData {
  final String svgAsset;
  final Function(BuildContext) label;
  final Widget view;

  _MainViewTabData({
    required this.svgAsset,
    required this.label,
    required this.view,
  });

  Widget toView() => view;

  Tab toTab(BuildContext context, bool isActive) => Tab(
        icon: SimpleTooltip(
          message: label(context) as String,
          child: SvgPicture.asset(
            svgAsset,
            color: isActive ? Theme.of(context).tabBarTheme.labelColor : Theme.of(context).tabBarTheme.unselectedLabelColor,
          ),
        ),
      );
}
