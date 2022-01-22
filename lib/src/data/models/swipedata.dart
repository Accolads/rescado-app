import 'package:flutter/gestures.dart';

class SwipeData {
  final Offset offset; // the offset from the center of the front card
  final double angle; // the angle by which the front card is rotated
  final bool isDragging; // indicates if the front card is being interacted with or not

  SwipeData({
    this.offset = Offset.zero,
    this.angle = 0,
    this.isDragging = false,
  });

  SwipeData copyWith({
    Offset? offset,
    double? angle,
    bool? isDragged,
  }) =>
      SwipeData(
        offset: offset ?? this.offset,
        angle: angle ?? this.angle,
        isDragging: isDragged ?? this.isDragging,
      );
}
