import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/card_data.dart';
import 'package:rescado/src/data/repositories/card_repository.dart';
import 'package:rescado/src/services/controllers/filter_controller.dart';
import 'package:rescado/src/utils/logger.dart';

final cardControllerProvider = StateNotifierProvider<CardController, AsyncValue<CardData>>(
  (ref) => CardController(ref.read).._initialize(),
);

class CardController extends StateNotifier<AsyncValue<CardData>> {
  static final _logger = addLogger('CardController');

  final Reader _read;

  late double _boxWidth;

  CardController(this._read) : super(const AsyncLoading());

  void _initialize() async {
    _logger.d('initialize()');
    state = const AsyncLoading();

    // Get some cards to start with, and make the stack interactable
    state = AsyncData(CardData(
      animals: await _fetchCards(),
      isDraggable: true,
    ));
  }

  Future<List<Animal>> _fetchCards() async {
    // _logger.d('fetchCards()');

    if (state.value != null && state.value!.animals.length >= RescadoConstants.swipeableStackCriticalSize) {
      // No need to fetch new cards -- we still got enough
      return [];
    }

    return await _read(cardRepositoryProvider).generate(
      cardFilter: _read(filterControllerProvider),
    );
  }

  void startDragging() {
    _logger.d('startDragging()');

    if (!state.value!.isDraggable) {
      // Not allowed to interact with the card apparently
      return;
    }

    state = AsyncData(state.value!.copyWith(
      isTouched: true,
      isDragging: true,
    ));
  }

  void handleDragging(DragUpdateDetails dragUpdateDetails) {
    // _logger.d('handleDragging()');

    if (!state.value!.isDraggable) {
      // Not allowed to interact with the card apparently
      return;
    }

    // Calculate new offset (old offset + distance dragged)
    final offset = state.value!.offset + dragUpdateDetails.delta;
    // Calculate new angle (current x / max width * maximum angle * π/180, for radians)
    final angle = offset.dx / _boxWidth * RescadoConstants.swipeableCardRotationAngle * pi / 180;

    state = AsyncData(state.value!.copyWith(
      offset: offset,
      angle: angle,
    ));

    // print('offset: ${state.value!.offset}');
  }

  void endDragging() {
    _logger.d('endDragging()');

    if (!state.value!.isDraggable) {
      // Not allowed to interact with the card apparently
      return;
    }

    final verticalOffset = state.value!.offset.dx;
    _logger.i('Vertical offset was $verticalOffset');

    if (verticalOffset <= -RescadoConstants.swipeableCardDragOffset) {
      return swipeLeft();
    }
    if (verticalOffset >= RescadoConstants.swipeableCardDragOffset) {
      return swipeRight();
    }

    // Return to original position
    state = AsyncData(state.value!.copyWith(
      offset: Offset.zero,
      angle: 0,
      isDragging: false,
    ));
  }

  void swipeLeft() {
    _logger.d('swipeLeft()');

    if (!state.value!.isDraggable) {
      // Not allowed to interact with the card apparently
      return;
    }

    // TODO Persist via API

    state = AsyncData(state.value!.copyWith(
      offset: state.value!.offset + Offset(-_boxWidth, -_boxWidth / 2),
      angle: -RescadoConstants.swipeableCardRotationAngle * pi / 180,
      isTouched: true,
      isDraggable: false,
      isDragging: false,
      isDragged: true,
    ));

    Future.delayed(RescadoConstants.swipeableCardAnimationDuration, removeTopCard);
  }

  void swipeRight() {
    _logger.d('swipeRight()');

    if (!state.value!.isDraggable) {
      // Not allowed to interact with the card apparently
      return;
    }

    // TODO Persist via API

    state = AsyncData(state.value!.copyWith(
      offset: state.value!.offset + Offset(_boxWidth, -_boxWidth / 2),
      angle: RescadoConstants.swipeableCardRotationAngle * pi / 180,
      isTouched: true,
      isDraggable: false,
      isDragging: false,
      isDragged: true,
    ));

    Future.delayed(RescadoConstants.swipeableCardAnimationDuration, removeTopCard);
  }

  void removeTopCard() async {
    _logger.d('removeTopCard()');

    state = AsyncData(state.value!.copyWith(
      animals: [...state.value!.animals.sublist(1), ...(await _fetchCards())],
      offset: Offset.zero,
      angle: 0,
      isTouched: false,
      isDraggable: true,
      isDragged: false,
    ));
  }

  void cacheBoxWidth(double width) {
    // _logger.d('cacheBoxWidth()');

    _boxWidth = width;
  }
}
