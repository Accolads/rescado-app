import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/switch_data.dart';
import 'package:rescado/src/utils/logger.dart';

final switchControllerProvider = StateNotifierProvider<SwitchController, SwitchData>(
  (_) => SwitchController().._initialize(),
);

class SwitchController extends StateNotifier<SwitchData> {
  static final _logger = addLogger('SwitchController');

  SwitchController() : super(SwitchData());

  void _initialize() {
    _logger.d('initialize()');

    // Move knob to the left to start
    state = state.copyWith(
      horizontalOffset: state.maxLeftHorizontalOffset,
    );
  }

  void onTap([SwitchPosition? position]) {
    _logger.d('onTap()');

    if (position == SwitchPosition.left) {
      _logger.i('Knob position moving to the left');
      state = state.copyWith(
        horizontalOffset: state.maxLeftHorizontalOffset,
        isDragging: false,
      );
      return;
    }
    if (position == SwitchPosition.right) {
      _logger.i('Knob position moving to the right');
      state = state.copyWith(
        horizontalOffset: state.maxRightHorizontalOffset,
        isDragging: false,
      );
      return;
    }

    _logger.i('Knob position moving to the opposite side');
    state = state.copyWith(
      horizontalOffset: state.horizontalOffset > 0 ? state.maxLeftHorizontalOffset : state.maxRightHorizontalOffset,
      isDragging: false,
    );
  }

  void startDragging() {
    _logger.d('startDragging()');

    state = state.copyWith(
      isDragging: true,
    );
  }

  void handleDragging(DragUpdateDetails dragUpdateDetails) {
    // _logger.d('handleDragging()');

    // Calculate new offset (old offset + distance dragged)
    final horizontalOffset = state.horizontalOffset + dragUpdateDetails.delta.dx;
    _logger.d('Left: ${state.maxLeftHorizontalOffset} | Right: ${state.maxRightHorizontalOffset} | Current: $horizontalOffset');

    // Do nothing if know is dragged past track
    if (horizontalOffset < state.maxLeftHorizontalOffset || horizontalOffset > state.maxRightHorizontalOffset) {
      return;
    }

    state = state.copyWith(
      horizontalOffset: horizontalOffset,
    );
  }

  void endDragging() {
    _logger.d('endDragging()');

    state = state.copyWith(
      horizontalOffset: state.horizontalOffset <= 0 ? state.maxLeftHorizontalOffset : state.maxRightHorizontalOffset,
      isDragging: false,
    );
  }
}
