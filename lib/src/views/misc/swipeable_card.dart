import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/controllers/swipe_controller.dart';
import 'package:rescado/src/data/models/swipedata.dart';

// WIP. Orphan file currently unused and in the wrong location. Final implementation won't be a/one card either so naming is nok as well.
class SwipeableCard extends ConsumerWidget {
  final String imageUrl;

  const SwipeableCard({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.expand(
      child: _buildFrontCard(context, ref),
    );
  }

  // Builds the front card, which is a regular card, but intractable.
  Widget _buildFrontCard(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onPanStart: (_) => ref.read(swipeControllerProvider.notifier).startDragging(MediaQuery.of(context).size),
      onPanUpdate: (DragUpdateDetails dragUpdateDetails) => ref.read(swipeControllerProvider.notifier).handleDragging(dragUpdateDetails),
      onPanEnd: (_) => ref.read(swipeControllerProvider.notifier).endDragging(),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return ref.watch(swipeControllerProvider).when(
            data: (SwipeData swipeData) {
              return LayoutBuilder(
                // required to know the center of the widget for rotation
                builder: (_, constraints) {
                  final center = constraints.smallest.center(Offset.zero);
                  return AnimatedContainer(
                      curve: Curves.elasticOut,
                      duration: Duration(seconds: swipeData.isDragged ? 0 : 1),
                      transform: Matrix4.identity()
                        ..translate(center.dx, center.dy) // rotate around center
                        ..rotateZ(swipeData.angle) // rotate around center
                        ..translate(-center.dx, -center.dy) // rotate around center
                        ..translate(swipeData.offset.dx, swipeData.offset.dy), // translate the dragged offset
                      child: _buildCard());
                },
              );
            },
            error: (Object error, StackTrace? stackTrace) {
              return const Text('error');
            },
            loading: () {
              return const Text('loading');
            },
          );
        },
      ),
    );
  }

  // Builds a big card to add to the stack.
  Widget _buildCard() {
    return Container(
      // TODO use BigCard once the previously created UI widgets are back in place
      decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)),
    );
  }
}
