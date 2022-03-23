import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/switch_data.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/services/controllers/switch_controller.dart';
import 'package:rescado/src/utils/extensions.dart';

class ChoiceToggle extends ConsumerWidget {
  const ChoiceToggle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelPadding = ref.watch(switchControllerProvider).trackWidth * 3;

    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => ref.read(switchControllerProvider.notifier).onTap(SwitchPosition.left),
            child: Padding(
              padding: EdgeInsets.only(right: labelPadding),
              child: Text(
                context.i10n.labelList,
                style: ref.watch(switchControllerProvider).position == SwitchPosition.left ? const TextStyle(fontWeight: FontWeight.w800) : null,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(switchControllerProvider.notifier).onTap(),
            onHorizontalDragStart: (_) => ref.read(switchControllerProvider.notifier).startDragging(),
            onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) => ref.read(switchControllerProvider.notifier).handleDragging(dragUpdateDetails),
            onHorizontalDragEnd: (_) => ref.read(switchControllerProvider.notifier).endDragging(),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: ref.watch(switchControllerProvider).trackWidth,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: ref.watch(settingsControllerProvider).activeTheme.borderColor,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                AnimatedContainer(
                  duration: ref.watch(switchControllerProvider).isDragging ? Duration.zero : const Duration(milliseconds: 150),
                  curve: ref.watch(switchControllerProvider).isDragging ? Curves.linear : Curves.easeOut,
                  transform: Matrix4.identity()..translate(ref.watch(switchControllerProvider).horizontalOffset, 0), // translate the dragged offset,
                  child: Container(
                    width: ref.watch(switchControllerProvider).knobWidth,
                    height: ref.watch(switchControllerProvider).knobWidth,
                    decoration: BoxDecoration(
                      color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(switchControllerProvider.notifier).onTap(SwitchPosition.right),
            child: Padding(
              padding: EdgeInsets.only(left: labelPadding),
              child: Text(
                context.i10n.labelGrid,
                style: ref.watch(switchControllerProvider).position == SwitchPosition.right ? const TextStyle(fontWeight: FontWeight.w800) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
