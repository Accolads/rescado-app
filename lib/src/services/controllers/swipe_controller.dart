import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/swipedata.dart';
import 'package:rescado/src/utils/logger.dart';

final swipeControllerProvider = StateNotifierProvider<SwipeController, SwipeData>(
  (ref) => SwipeController(ref.read).._initialize(),
);

class SwipeController extends StateNotifier<SwipeData> {
  static final _logger = addLogger('SwipeController');

  final Reader _read; // ignore: unused_field

  late Size _viewport;

  SwipeController(this._read) : super(SwipeData());

  void _initialize() async {
    _logger.d('initialize()');

    // Temporary stuff.
  }

  void startDragging(Size viewport) {
    _logger.d('startDragging()');

    // Save the current screen's dimensions so we can calculate the angle when dragging.
    _viewport = viewport;

    state = state.copyWith(
      isDragged: true,
    );
  }

  void handleDragging(DragUpdateDetails dragUpdateDetails) {
    // _logger.d('handleDragging()'); // Gets fired every pixel we move. Very spammy log.

    // Calculate new offset (old offset + distance dragged)
    final offset = state.offset + dragUpdateDetails.delta;
    // Calculate new angle ( current x / max width * maximum angle * π/180, for radians)
    final angle = offset.dx / _viewport.width * RescadoConstants.swipeableCardRotationAngle * pi / 180;

    state = state.copyWith(
      offset: offset,
      angle: angle,
    );
  }

  void endDragging() {
    _logger.d('endDragging()');

    // Swiped the card to the right
    if (state.offset.dx >= RescadoConstants.swipeableCardDragOffset) {
      _logger.i('User swiped right (horizontal offset: ${state.offset.dx})');

      state = state.copyWith(
        offset: state.offset + Offset(_viewport.width * 3, 0),
        angle: RescadoConstants.swipeableCardRotationAngle,
        isDragged: false,
      );
      return;
    }

    // Swiped the card to the left
    if (state.offset.dx <= -RescadoConstants.swipeableCardDragOffset) {
      _logger.i('User swiped left (horizontal offset: ${state.offset.dx})');

      state = state.copyWith(
        offset: state.offset - Offset(_viewport.width * 3, 0),
        angle: -RescadoConstants.swipeableCardRotationAngle,
        isDragged: false,
      );
      return;
    }

    // Didn't swipe far enough so we'll reset the card's position
    _logger.i('User performed a "neutral" swipe (horizontal offset: ${state.offset.dx})');

    state = state.copyWith(
      offset: Offset.zero,
      angle: 0,
      isDragged: false,
    );
  }
}
