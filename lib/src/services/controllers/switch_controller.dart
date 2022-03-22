import 'package:flutter/cupertino.dart';
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
  static final _logger = addLogger('SwitchController');

  SwitchController() : super(SwitchData());

  void startDragging() {
    _logger.d('startDragging()');

    state = state.copyWith(
      isDragging: true,
    );
  }

  void handleDragging(DragUpdateDetails dragUpdateDetails) {
    _logger.d('handleDragging()');

    // Calculate new offset (old offset + distance dragged)
    final offset = state.offset + dragUpdateDetails.delta;
    // Do nothing if know is dragged past track
    if (offset.dx < 0.0 || offset.dx > state.trackWidth - state.knobWidth) {
      return;
    }

    state = state.copyWith(offset: offset);
  }

  void stopDragging (){
    _logger.d('endDragging()');

    state = state.copyWith(
      isDragging: false,
    );
  }
}
