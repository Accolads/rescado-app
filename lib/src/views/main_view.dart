import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/services/controllers/main_tab_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/discover_view.dart';
import 'package:rescado/src/views/misc/circle_tab_indicator.dart';
import 'package:rescado/src/views/misc/simple_tooltip.dart';
import 'package:rescado/src/views/profile_view.dart';
import 'package:rescado/src/views/swipe_view.dart';

// Main view of the application. What a logged in user sees and uses to navigate through the app..
class MainView extends ConsumerStatefulWidget {
  static const viewId = 'MainView';

  const MainView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> with SingleTickerProviderStateMixin {

  @override
  void didChangeDependencies() {
    ref.watch(tabControllerProvider.notifier).setTabController(
          TabController(initialIndex: 1, length: _tabData.length, vsync: this),
        );
    super.didChangeDependencies();
  }

  final _tabData = [
    _MainViewTabData(
      svgAsset: RescadoConstants.iconCompass,
      label: (BuildContext context) => context.i10n.labelDiscover,
      view: const DiscoverView(),
    ),
    _MainViewTabData(
      svgAsset: RescadoConstants.iconLogo,
      label: (BuildContext context) => context.i10n.labelSwipe,
      view: const SwipeView(),
    ),
    _MainViewTabData(
      svgAsset: RescadoConstants.iconUser,
      label: (BuildContext context) => context.i10n.labelProfile,
      view: const ProfileView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TabBarView(
          controller: ref.watch(tabControllerProvider),
          physics: const NeverScrollableScrollPhysics(),
          children: _tabData.map((data) => data.toView()).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ref.watch(settingsControllerProvider).activeTheme.backgroundVariantColor,
          border: Border(
            top: BorderSide(
              width: 1.0,
              color: ref.watch(settingsControllerProvider).activeTheme.borderColor,
            ),
          ),
        ),
        child: SafeArea(
          child: TabBar(
            controller: ref.watch(tabControllerProvider),
            indicator: CircleTabIndicator(
              color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            tabs: _tabData.asMap().entries.map((data) => data.value.toTab(context, data.key == ref.watch(tabControllerProvider)!.index)).toList(),
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
