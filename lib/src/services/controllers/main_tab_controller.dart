import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/services/controllers/like_controller.dart';
import 'package:rescado/src/utils/logger.dart';
import 'package:rescado/src/views/profile_view.dart';

final tabControllerProvider = StateNotifierProvider<MainTabController, int>(
  (ref) => MainTabController(ref.read),
);

class MainTabController extends StateNotifier<int> {
  static final _logger = addLogger('MainTabController');

  final Reader _read;

  MainTabController(this._read) : super(RescadoConstants.mainViewInitialTab);

  void setActiveTab(int tab) {
    _logger.d('setActiveTab()');
    state = tab;
  }
}
