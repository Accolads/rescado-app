import 'package:flutter/gestures.dart';
import 'package:rescado/src/data/models/animal.dart';

class CardData {
  final List<Animal> animals;
  final Offset offset; // the offset from the center of the front card
  final double angle; // the angle by which the front card is rotated
  final bool isTouched; // indicates that the user is interacting with the card (and not an animation)
  final bool isDraggable; // indicates if the front card is draggable or not
  final bool isDragging; // indicates if the front card is being dragged with or not
  final bool isDragged; // is true when the card was dragged to a side, but not yet removed from the stack

  bool get shouldPopUp => isDragging || isDragged;

  bool get shouldAnimate => !isDragging && isTouched;

  CardData({
    this.animals = const [],
    this.offset = Offset.zero,
    this.angle = 0.0,
    this.isTouched = false,
    this.isDraggable = false,
    this.isDragging = false,
    this.isDragged = false,
  });

  CardData copyWith({
    final List<Animal>? animals,
    Offset? offset,
    double? angle,
    bool? isTouched,
    bool? isDraggable,
    bool? isDragging,
    bool? isDragged,
  }) =>
      CardData(
        animals: animals ?? this.animals,
        offset: offset ?? this.offset,
        angle: angle ?? this.angle,
        isTouched: isTouched ?? this.isTouched,
        isDraggable: isDraggable ?? this.isDraggable,
        isDragging: isDragging ?? this.isDragging,
        isDragged: isDragged ?? this.isDragged,
      );
}
