import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/utils/extensions.dart';

class ChoiceToggle extends ConsumerStatefulWidget {
  const ChoiceToggle({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ChoiceToggle> createState() => _ChoiceToggleState();
}

class _ChoiceToggleState extends ConsumerState<ChoiceToggle> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final _width = 33.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 50.0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: _width * 3),
              child: Text(
                context.i10n.labelList,
                // style: widget.rightActive ? null : const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext context, Widget? child) {
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: _width,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color: ref.watch(settingsControllerProvider).activeTheme.borderColor,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    Draggable(
                      feedback: _buildToggle(),
                      child: _buildToggle(),
                      axis: Axis.horizontal,
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: _width * 3),
              child: Text(
                context.i10n.labelGrid,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );

  Widget _buildToggle() => Container(
        width: 15.0,
        height: 15.0,
        decoration: BoxDecoration(
          color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
          shape: BoxShape.circle,
        ),
      );
}
