import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/carddata.dart';
import 'package:rescado/src/services/controllers/card_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/services/controllers/swipe_controller.dart';
import 'package:rescado/src/views/buttons/floating_button.dart';

// Stack of cards the user can swipe left or right
class SwipeableStack extends StatelessWidget {
  const SwipeableStack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
        // WIP hardcoded, temporary stuff for now
        return ref.watch(cardControllerProvider).when(
              data: (CardData cardData) => Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  if (cardData.cards.length >= 3) SwipeableCard(cardData: cardData, index: 2),
                  if (cardData.cards.length >= 2) SwipeableCard(cardData: cardData, index: 1),
                  _makeInteractable(context, ref, SwipeableCard(cardData: cardData, index: 0)),
                ],
              ),
              error: (_, __) => const Text('error!!'),
              loading: () => const CircularProgressIndicator(),
            );
      });

  // Builds the front card, which is a regular card, but draggable.
  Widget _makeInteractable(BuildContext context, WidgetRef ref, Widget child) => GestureDetector(
        onPanStart: (_) => ref.read(swipeControllerProvider.notifier).startDragging(MediaQuery.of(context).size),
        onPanUpdate: (DragUpdateDetails dragUpdateDetails) => ref.read(swipeControllerProvider.notifier).handleDragging(dragUpdateDetails),
        onPanEnd: (_) => ref.read(swipeControllerProvider.notifier).endDragging(),
        child: LayoutBuilder(
          builder: (_, constraints) {
            // need LayoutBuilder to know the center of the widget for rotation/tilting the card
            final center = constraints.smallest.center(Offset.zero);
            return AnimatedContainer(
              curve: Curves.elasticOut,
              duration: Duration(seconds: ref.watch(swipeControllerProvider).isDragged ? 0 : 2),
              transform: Matrix4.identity()
                ..translate(center.dx, center.dy) // rotate around center
                ..rotateZ(ref.watch(swipeControllerProvider).angle) // rotate around center
                ..translate(-center.dx, -center.dy) // rotate around center
                ..translate(ref.watch(swipeControllerProvider).offset.dx, ref.watch(swipeControllerProvider).offset.dy), // translate the dragged offset
              child: child,
            );
          },
        ),
      );
}

// A swipeable card to use in a swipeable stack. Render max 3 per stack or will throw range errors.
class SwipeableCard extends ConsumerStatefulWidget {
  final CardData cardData;
  final int index;

  const SwipeableCard({
    Key? key,
    required this.cardData,
    required this.index,
  }) : super(key: key);

  @override
  _SwipeableCardState createState() => _SwipeableCardState();
}

class _SwipeableCardState extends ConsumerState<SwipeableCard> {
  final cardWidth = 300.0; // Preferred width of a card
  final cardHeight = 440.0; // Preferred height of a card
  final margins = [0.0, 55.0, 100.0, 100.0]; // Distance each card should be from the top, top card to bottom card.

  bool hasAnimated = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 100),
      () => setState(() {
        hasAnimated = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If card won't fit its parent, make it 90% of the parent's width
    final maxWidth = MediaQuery.of(context).size.width * .9;
    // Calculations so cards with a higher index, so lower in the stack, are ±6% smaller than the card above
    final actualWidth = (cardWidth > maxWidth ? maxWidth : cardWidth) * (1 - widget.index / 16);
    final actualHeight = cardHeight * (1 - widget.index / 16);

    return Center(
      // The actual card
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        width: hasAnimated ? actualWidth : actualWidth - 10.0,
        height: hasAnimated ? actualHeight : actualHeight - 10.0,
        margin: EdgeInsets.only(top: margins[hasAnimated ? widget.index : widget.index + 1]),
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
                  onTap: () => print('clicked the photo'), // ignore: avoid_print
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.cardData.cards[widget.index].photos[0].reference,
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
                                widget.cardData.cards[widget.index].name,
                                style: const TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.cardData.cards[widget.index].breed,
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
                    semanticsLabel: AppLocalizations.of(context)!.labelSkip,
                    onPressed: () => print('skip'), // ignore: avoid_print
                  ),
                  FloatingButton(
                    color: const Color(0xFFEE575F),
                    size: FloatingButtonSize.big,
                    svgAsset: RescadoConstants.iconHeartOutline,
                    semanticsLabel: AppLocalizations.of(context)!.labelLike,
                    onPressed: () => print('like'), // ignore: avoid_print
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
