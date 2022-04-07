import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/views/buttons/floating_button.dart';

class ListItem extends ConsumerWidget {
  final String label;
  final String? subLabel1;
  final String? subLabel2;
  final String imageUrl;
  final FloatingButton? button;
  final Function onPressed;

  final double _borderRadius = 20.0;

  const ListItem({
    Key? key,
    required this.label,
    this.subLabel1,
    this.subLabel2,
    required this.imageUrl,
    this.button,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Material(
          color: ref.watch(settingsControllerProvider).activeTheme.accentDimmedColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(_borderRadius),
            splashColor: Platform.isAndroid ? ref.watch(settingsControllerProvider).activeTheme.accentColor.withOpacity(.2) : Colors.transparent,
            highlightColor: Platform.isAndroid ? Colors.transparent : ref.watch(settingsControllerProvider).activeTheme.accentColor.withOpacity(.2),
            onTap: () => onPressed(),
            child: Padding(
              padding: const EdgeInsets.all(7.5),
              child: Row(
                children: [
                  SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (subLabel1 != null)
                            Text(
                              subLabel1!,
                              style: TextStyle(
                                fontSize: 11.0,
                                color: ref.watch(settingsControllerProvider).activeTheme.primaryColor.withOpacity(0.6),
                              ),
                            ),
                          if (subLabel2 != null)
                            Text(
                              subLabel2!,
                              style: TextStyle(
                                fontSize: 11.0,
                                color: ref.watch(settingsControllerProvider).activeTheme.primaryColor.withOpacity(0.6),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (button != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: button!,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
