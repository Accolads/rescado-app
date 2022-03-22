import 'package:flutter/cupertino.dart';
import 'package:rescado/src/constants/rescado_constants.dart';

enum SwitchPosition {
  unknown,
  left,
  right,
}

class SwitchData {
  final Offset offset;
  final bool isDragging;

  final _trackWidth = 33.0;
  final _knobWidth = 15.0;

  double get trackWidth => _trackWidth;

  double get knobWidth => _knobWidth;

  SwitchPosition get position {
    if (offset.dx == 0.0) {
      return SwitchPosition.left;
    }
    if (offset.dx == _trackWidth - _knobWidth) {
      return SwitchPosition.right;
    }
    return SwitchPosition.unknown;
  }

  SwitchData({
    this.offset = Offset.zero,
    this.isDragging = false,
  });

  SwitchData copyWith({
    final Offset? offset,
    final bool? isDragging,
  }) =>
      SwitchData(
        offset: offset ?? this.offset,
        isDragging: isDragging ?? this.isDragging,
      )
}
