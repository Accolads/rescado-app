import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/switch_data.dart';
import 'package:rescado/src/utils/logger.dart';

final switchControllerProvider = StateNotifierProvider<SwitchController, SwitchData>(
  (_) => SwitchController(),
);

enum LikesLayout {
  list,
  grid,
}

class SwitchController extends StateNotifier<SwitchData> {
  static final _logger = addLogger('MainTabController');

  SwitchController() : super(SwitchData());

  // void setLayout(LikesLayout layout) {
  //   _logger.d('setLayout()');
  //   state = layout;
  // }
}
