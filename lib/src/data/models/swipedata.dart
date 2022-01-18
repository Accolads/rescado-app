import 'package:flutter/gestures.dart';

class SwipeData {
  Offset offset; // the offset from the center of the front card
  double angle; // the angle by which the front card is rotated
  bool isDragged; // indicates if the front card is being interacted with or not

  SwipeData({
    this.offset = Offset.zero,
    this.angle = 0,
    this.isDragged = false,
  });

  SwipeData copyWith({
    Offset? offset,
    double? angle,
    bool? isDragged,
  }) =>
      SwipeData(
        offset: offset ?? this.offset,
        angle: angle ?? this.angle,
        isDragged: isDragged ?? this.isDragged,
      );
}
