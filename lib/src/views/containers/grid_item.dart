import 'package:flutter/material.dart';
import 'package:rescado/src/views/buttons/rounded_button.dart';

class GridItem extends StatefulWidget {
  final String image;
  final RoundedButton roundedButton;

  const GridItem({
    Key? key,
    required this.image,
    required this.roundedButton,
  }) : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool showAction = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () => setState(() => showAction = !showAction),
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: showAction ? 0.5 : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.image),
                  ),
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: showAction ? Center(child: widget.roundedButton) : const SizedBox(),
            ),
          ],
        ));
  }
}
