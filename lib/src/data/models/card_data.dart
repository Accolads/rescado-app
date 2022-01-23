import 'package:flutter/gestures.dart';
import 'package:rescado/src/data/models/animal.dart';

class CardData {
  final List<Animal> animals;
  final Offset offset; // the offset from the center of the front card
  final double angle; // the angle by which the front card is rotated
  final bool isDraggable; // indicates if the front card is draggable or not
  final bool isDragging; // indicates if the front card is being interacted with or not

  CardData({
    this.animals = const [],
    this.offset = Offset.zero,
    this.angle = 0,
    this.isDraggable = false,
    this.isDragging = false,
  });

  CardData copyWith({
    final List<Animal>? animals,
    Offset? offset,
    double? angle,
    bool? isDraggable,
    bool? isDragging,
  }) =>
      CardData(
        animals: animals ?? this.animals,
        offset: offset ?? this.offset,
        angle: angle ?? this.angle,
        isDraggable: isDraggable ?? this.isDraggable,
        isDragging: isDragging ?? this.isDragging,
      );
}
