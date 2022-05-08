import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedLogo extends StatefulWidget {
  final bool play;

  const AnimatedLogo({
    Key? key,
    this.play = true,
  }) : super(key: key);

  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedLogo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.play) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Stack(
          children: <Widget>[
            SvgPicture.asset('assets/logo/heart.svg'),
            ...[1, 2, 3, 4].map(
              (i) {
                var value = _animationController.value * 50;
                var y = (value > i * 10 && value < i * 10 + 10) ? value - i * 10 : 0.0;
                // Not the animation I wanted but doesn't look too bad lol, so works for now ✌️
                return Transform.translate(
                  offset: Offset(0, -y),
                  child: SvgPicture.asset('assets/logo/toe$i.svg'),
                );
              },
            ),
          ],
        ),
      );
}
