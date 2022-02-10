import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/utils/logger.dart';

final tabControllerProvider = StateNotifierProvider<MainTabController, int>(
  (_) => MainTabController(),
);

class MainTabController extends StateNotifier<int> {
  static final _logger = addLogger('MainTabController');

  MainTabController() : super(RescadoConstants.mainViewInitialTabIndex);

  void setActiveTab(int tabIndex) {
    _logger.d('setActiveTab()');
    state = tabIndex >= 0 && tabIndex < 3 ? tabIndex : 0; //RescadoConstants.mainViewInitialTabIndex;
  }
}
