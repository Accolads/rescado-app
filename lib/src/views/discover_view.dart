import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/buttons/floating_button.dart';
import 'package:rescado/src/views/containers/full_page.dart';

// Placeholder view.
class DiscoverView extends StatelessWidget {
  static const viewId = 'DiscoverView';
  static const tabIndex = 0;

  const DiscoverView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FullPage(
        title: context.i10n.labelDiscover,
        body: Center(
          child: Column(
            children: <Widget>[
              const Text(
                'Placeholder DiscoverView',
              ),
              const SizedBox(
                height: 50.0,
              ),
              // For demo purposes
              FloatingButton(
                semanticsLabel: 'Do not press',
                svgAsset: RescadoConstants.iconHeartBroken,
                onPressed: () {
                  // 💣
                  FirebaseCrashlytics.instance.crash();
                },
              ),
            ],
          ),
        ),
      );
}
