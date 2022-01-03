import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rescado/constants/rescado_style.dart';

// Fixed width (!) button with icon and label. Should only be used for small command-like labels.
class ActionButton extends StatefulWidget {
  final String label;
  final String svgAsset;
  final Function onPressed;

  final double _borderRadius = 50.0;

  const ActionButton({
    Key? key,
    required this.label,
    required this.svgAsset,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _animation = ColorTween(
      begin: Theme.of(context).colorScheme.secondaryVariant,
      end: Theme.of(context).colorScheme.secondary,
    ).animate(_animationController);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Material(
            color: Theme.of(context).colorScheme.secondaryVariant,
            borderRadius: BorderRadius.circular(widget._borderRadius),
            child: InkWell(
              borderRadius: BorderRadius.circular(widget._borderRadius),
              splashColor: Theme.of(context).colorScheme.secondary.withOpacity(.2),
              highlightColor: Colors.transparent,
              onTap: () => widget.onPressed(),
              child: _buildButton(context),
            ),
          )
        : AnimatedBuilder(
            animation: _animationController,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                color: _animation.value!.withOpacity(1 - _animationController.value / 2),
                borderRadius: BorderRadius.circular(widget._borderRadius),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (_) => _animationController.forward(),
                onTapCancel: () => _animationController.reverse(),
                onTapUp: (_) {
                  _animationController.reverse();
                  widget.onPressed();
                },
                child: _buildButton(context),
              ),
            ),
          );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      width: 160.0,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: SvgPicture.asset(
                // TODO Make this SVG wiggle when the button is being held down :-)
                widget.svgAsset,
                color: Theme.of(context).colorScheme.secondary,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            widget.label,
            style: RescadoStyle.actionLabel(context),
          ),
        ],
      ),
    );
  }
}
