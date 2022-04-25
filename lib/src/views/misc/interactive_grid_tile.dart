import 'package:flutter/material.dart';
import 'package:rescado/src/views/buttons/floating_button.dart';

class InteractiveGridTile extends StatefulWidget {
  final String image;
  final FloatingButton floatingButton;

  const InteractiveGridTile({Key? key, required this.image, required this.floatingButton}) : super(key: key);

  @override
  _GridTileState createState() => _GridTileState();
}

class _GridTileState extends State<InteractiveGridTile> {
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
              child: showAction ? Center(child: widget.floatingButton) : const SizedBox(),
            ),
          ],
        ));
  }
}
