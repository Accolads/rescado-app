import 'package:flutter/material.dart';
import 'package:rescado/src/views/buttons/rounded_button.dart';

class GridItem extends StatefulWidget {
  final String image;
  final RoundedButton roundedButton;
  final Function onPressed;

  const GridItem({
    Key? key,
    required this.image,
    required this.roundedButton,
    required this.onPressed,
  }) : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  final Duration _duration = const Duration(milliseconds: 100);

  bool _showAction = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPressed(),
      //TODO set showAction back to false after 5 seconds
      onLongPress: () => setState(() => _showAction = !_showAction),
      child: Stack(
        children: [
          AnimatedOpacity(
            duration: _duration,
            opacity: _showAction ? 0.5 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.image),
                ),
              ),
            ),
          ),
          AnimatedScale(
            duration: _duration,
            scale: _showAction ? 1 : 0,
            child: Center(
              child: widget.roundedButton,
            ),
          ),
        ],
      ),
    );
  }
}
