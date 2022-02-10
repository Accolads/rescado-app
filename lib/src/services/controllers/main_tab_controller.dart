import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/utils/logger.dart';

final tabControllerProvider = StateNotifierProvider<MainTabController, TabController?>(
  (_) => MainTabController(),
);

class MainTabController extends StateNotifier<TabController?> {
  static final _logger = addLogger('MainTabController');

  MainTabController() : super(null);

  void setTabController(TabController tabController) {
    state = tabController;
  }

  void setActiveTab(int tabIndex) {
    _logger.d('setActiveTab()');
    state?.animateTo(tabIndex);
  }
}
