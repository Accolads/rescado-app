import 'package:flutter/material.dart';

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({required Color color}) : _painter = _CirclePainter(color);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final double _radius;
  final Paint _paint;

  _CirclePainter(Color color)
      : _radius = 8.0,
        _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) => canvas.drawCircle(offset + Offset(config.size!.width / 2, -_radius), _radius, _paint);
}
