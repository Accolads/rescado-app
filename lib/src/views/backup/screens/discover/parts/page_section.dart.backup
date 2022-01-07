import 'package:flutter/material.dart';
import 'package:rescado/src/ui/styles/rescado_style.dart';

class PageSection extends StatelessWidget {
  final String label;
  final String? actionLabel;
  final Function? action;
  final Widget child;

  const PageSection({Key? key, required this.label, this.actionLabel, this.action, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (action != null && actionLabel != null)
              TextButton(
                child: Text(
                  actionLabel!,
                  style: RescadoStyle.cardSmallTitle(context).copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onPressed: () => action!(),
                style: const ButtonStyle(
                  //TODO need effect?
                  splashFactory: NoSplash.splashFactory,
                ),
              ),
          ],
        ),
        child
      ],
    );
  }
}
