import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/constants/rescado_constants.dart';
import 'package:rescado/models/swipedata.dart';
import 'package:rescado/utils/logger.dart';

final swipeControllerProvider = StateNotifierProvider<SwipeController, AsyncValue<SwipeData>>(
  (ref) => SwipeController(ref.read).._initialize(),
);

class SwipeController extends StateNotifier<AsyncValue<SwipeData>> {
  static final _logger = addLogger('SwipeController');

  final Reader _read; // ignore: unused_field

  late Size _viewport;

  SwipeController(this._read) : super(const AsyncValue.loading());

  void _initialize() async {
    _logger.d('initialize()');

    // Temporary stuff. We'll need a card_repository implentation to get API data we can use here.
    Future.delayed(const Duration(milliseconds: 4200), () {
      state = AsyncValue.data(SwipeData());
    });
  }

  void startDragging(Size viewport) {
    _logger.d('startDragging()');

    // Save the current screen's dimensions so we can calculate the angle when dragging.
    _viewport = viewport;

    var swipeData = state.value!.copyWith(
      isDragged: true,
    );
    state = AsyncValue.data(swipeData);
  }

  void handleDragging(DragUpdateDetails dragUpdateDetails) {
    // _logger.d('handleDragging()'); // Gets fired every pixel we move. Very spammy log.

    // Calculate new offset (old offset + distance dragged)
    var offset = state.value!.offset + dragUpdateDetails.delta;
    // Calculate new angle ( current x / max width * maximum angle * π/180, for radians)
    var angle = offset.dx / _viewport.width * RescadoConstants.swipeableCardRotationAngle * pi / 180;

    var swipeData = state.value!.copyWith(
      offset: offset,
      angle: angle,
    );
    state = AsyncValue.data(swipeData);
  }

  void endDragging() {
    _logger.d('endDragging()');

    // Swiped the card to the right
    if (state.value!.offset.dx >= RescadoConstants.swipeableCardDragOffset) {
      _logger.i('User swiped right (horizontal offset: ${state.value!.offset.dx})');

      var swipeData = state.value!.copyWith(
        offset: state.value!.offset + Offset(_viewport.width * 3, 0),
        angle: RescadoConstants.swipeableCardRotationAngle,
        isDragged: false,
      );
      state = AsyncValue.data(swipeData);
      return;
    }

    // Swiped the card to the left
    if (state.value!.offset.dx <= -RescadoConstants.swipeableCardDragOffset) {
      _logger.i('User swiped left (horizontal offset: ${state.value!.offset.dx})');

      var swipeData = state.value!.copyWith(
        offset: state.value!.offset - Offset(_viewport.width * 3, 0),
        angle: -RescadoConstants.swipeableCardRotationAngle,
        isDragged: false,
      );
      state = AsyncValue.data(swipeData);
      return;
    }

// Didn't swipe far enough so we'll reset the card's position
    _logger.i('User performed a "neutral" swipe (horizontal offset: ${state.value!.offset.dx})');

    var swipeData = state.value!.copyWith(
      offset: Offset.zero,
      angle: 0,
      isDragged: false,
    );
    state = AsyncValue.data(swipeData);
  }
}
