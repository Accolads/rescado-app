import 'package:flutter/material.dart';

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;
  final bool top;

  CircleTabIndicator({
    required Color color,
    this.top = false,
  }) : _painter = _CirclePainter(color, top);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final double _radius;
  final Paint _paint;
  final bool _top;

  _CirclePainter(Color color, this._top)
      : _radius = 7.5,
        // should be X.5 so the dot height is odd and it can sit in the middle of the 1px border
        _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) => canvas.drawCircle(offset + Offset(config.size!.width / 2, _top ? -_radius : config.size!.height), _radius, _paint);
}
