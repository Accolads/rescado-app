import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/services/controllers/swipe_controller.dart';
import 'package:rescado/src/views/buttons/floating_button.dart';

// Stack of cards the user can swipe left or right
class SwipeableStack extends ConsumerWidget {
  const SwipeableStack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox.expand(
        child: _buildTopCard(context, ref),
      );

  // Builds the front card, which is a regular card, but draggable.
  Widget _buildTopCard(BuildContext context, WidgetRef ref) => GestureDetector(
        onPanStart: (_) => ref.read(swipeControllerProvider.notifier).startDragging(MediaQuery.of(context).size),
        onPanUpdate: (DragUpdateDetails dragUpdateDetails) => ref.read(swipeControllerProvider.notifier).handleDragging(dragUpdateDetails),
        onPanEnd: (_) => ref.read(swipeControllerProvider.notifier).endDragging(),
        child: LayoutBuilder(
          builder: (_, constraints) {
            // need LayoutBuilder to know the center of the widget for rotation/tilting the card
            final center = constraints.smallest.center(Offset.zero);
            return AnimatedContainer(
                curve: Curves.elasticOut,
                duration: Duration(seconds: ref.watch(swipeControllerProvider).isDragged ? 0 : 3),
                transform: Matrix4.identity()
                  ..translate(center.dx, center.dy) // rotate around center
                  ..rotateZ(ref.watch(swipeControllerProvider).angle) // rotate around center
                  ..translate(-center.dx, -center.dy) // rotate around center
                  ..translate(ref.watch(swipeControllerProvider).offset.dx, ref.watch(swipeControllerProvider).offset.dy), // translate the dragged offset
                child: _buildCard(context, ref));
          },
        ),
      );

  // Builds a big card to add to the stack.
  Widget _buildCard(BuildContext context, WidgetRef ref) {
    // Cards will be 300 wide, unless its parent is smaller, in which case it'll take 90% of the parent's width
    const preferredWidth = 300.0;
    final safeWidth = MediaQuery.of(context).size.width * .9;
    const preferredHeight = 440.0;

    return Center(
      // The actual card
      child: Container(
        width: safeWidth > preferredWidth ? preferredWidth : safeWidth,
        height: preferredHeight,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: ref.watch(settingsControllerProvider).activeTheme.backgroundVariantColor,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: const [
            BoxShadow(
              // TODO we perhaps want to extract this BoxDecoration if we want to reuse it for modal popups in the future
              offset: Offset(0, 5),
              blurRadius: 15.0,
              spreadRadius: 1.0,
              color: Color(0x1A000000),
            )
          ],
        ),
        // The contents of the card
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // The photo at the top
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => print('clicked the photo'),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://cataas.com/cat',
                        fit: BoxFit.cover,
                      ),
                      // Shadowbox at the bottom with name and breed
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 150.0,
                          padding: const EdgeInsets.all(20.0),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0x00000000),
                                Color(0x90000000),
                                Color(0x90000000),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                'Jeffrey',
                                style: const TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Poesje',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Dislike/like buttons at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FloatingButton(
                    color: const Color(0xFFEE575F),
                    size: FloatingButtonSize.big,
                    svgAsset: RescadoConstants.iconCross,
                    semanticsLabel: 'dislike',
                    onPressed: () => print('dislike'),
                  ),
                  FloatingButton(
                    color: const Color(0xFFEE575F),
                    size: FloatingButtonSize.big,
                    svgAsset: RescadoConstants.iconHeartOutline,
                    semanticsLabel: 'like',
                    onPressed: () => print('like'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
