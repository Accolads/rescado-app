import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/swipedata.dart';
import 'package:rescado/src/services/controllers/card_controller.dart';
import 'package:rescado/src/utils/logger.dart';

final swipeControllerProvider = StateNotifierProvider<SwipeController, SwipeData>(
  (ref) => SwipeController(ref.read).._initialize(),
);

class SwipeController extends StateNotifier<SwipeData> {
  static final _logger = addLogger('SwipeController');

  final Reader _read;

  SwipeController(this._read) : super(SwipeData());

  void _initialize() async {
    _logger.d('initialize()');

    state = SwipeData();
  }

  void startDragging() {
    _logger.d('startDragging()');

    state = state.copyWith(
      isDragging: true,
    );
  }

  void handleDragging(DragUpdateDetails dragUpdateDetails) {
    // _logger.d('handleDragging()'); // Gets fired every pixel we move. Very spammy log.

    // Calculate new offset (old offset + distance dragged)
    final offset = state.offset + dragUpdateDetails.delta;
    // Calculate new angle ( current x / max width * maximum angle * π/180, for radians)
    final angle = offset.dx / 500 * RescadoConstants.swipeableCardRotationAngle * pi / 180;

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

      return performLike();
    }

    // Swiped the card to the left
    if (state.offset.dx <= -RescadoConstants.swipeableCardDragOffset) {
      _logger.i('User swiped left (horizontal offset: ${state.offset.dx})');

      return performSkip();
    }

    // Didn't swipe far enough so we'll reset the card's position
    _logger.i('User performed a "neutral" swipe (horizontal offset: ${state.offset.dx})');

    state = state.copyWith(
      offset: Offset.zero,
      angle: 0,
      isDragging: false,
    );
  }

  void performSkip() {
    _logger.d('performSkip()');

    Future.delayed(
      Duration(seconds: state.velocity),
      () {
        _initialize();
        _read(cardControllerProvider.notifier).nextCard(didLike: false);
      },
    );

    state = state.copyWith(
      offset: state.offset - const Offset(5000, 0),
      angle: -RescadoConstants.swipeableCardRotationAngle,
   //   isDragging: false,
    );
  }

  void performLike() {
    _logger.d('performLike()');

    Future.delayed(
      Duration(seconds: state.velocity),
      () {
        _initialize();
        _read(cardControllerProvider.notifier).nextCard(didLike: true);
      },
    );

    state = state.copyWith(
      offset: state.offset + const Offset(5000, 0),
      angle: RescadoConstants.swipeableCardRotationAngle,
    //  isDragging: false,
    );
  }
}
