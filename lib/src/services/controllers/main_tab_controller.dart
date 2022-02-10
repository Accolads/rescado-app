import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/utils/logger.dart';

final tabControllerProvider = StateNotifierProvider<MainTabController, AsyncValue<TabController>>(
  (_) => MainTabController(),
);

class MainTabController extends StateNotifier<AsyncValue<TabController>> {
  static final _logger = addLogger('MainTabController');

  MainTabController() : super(const AsyncLoading());

  void setTabController(TabController tabController) {
    state = AsyncData(tabController);
  }

  void setActiveTab(int tabIndex) {
    _logger.d('setActiveTab()');
    state.value?.animateTo(tabIndex);
    state = AsyncData(state.value!);
  }
}
