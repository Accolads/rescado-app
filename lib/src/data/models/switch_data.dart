enum SwitchPosition {
  left,
  right,
}

class SwitchData {
  final double horizontalOffset;
  final bool isDragging;

  final _trackWidth = 33.0;
  final _knobWidth = 15.0;

  double get trackWidth => _trackWidth;

  double get knobWidth => _knobWidth;

  double get maxLeftHorizontalOffset => -maxRightHorizontalOffset;

  double get maxRightHorizontalOffset => _trackWidth / 2 - _knobWidth / 2;

  SwitchPosition get position => horizontalOffset <= 0 ? SwitchPosition.left : SwitchPosition.right;

  SwitchData({
    this.horizontalOffset = 0.0,
    this.isDragging = false,
  });

  SwitchData copyWith({
    final double? horizontalOffset,
    final bool? isDragging,
  }) =>
      SwitchData(
        horizontalOffset: horizontalOffset ?? this.horizontalOffset,
        isDragging: isDragging ?? this.isDragging,
      );
}
