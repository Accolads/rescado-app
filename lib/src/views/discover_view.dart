import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/views/buttons/floating_button.dart';
import 'package:rescado/src/views/containers/full_page.dart';

// Placeholder view.
class DiscoverView extends StatelessWidget {
  static const viewId = 'DiscoverView';

  const DiscoverView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FullPage(
        title: AppLocalizations.of(context)!.labelDiscover,
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
                semanticsLabel: 'hello',
                svgAsset: RescadoConstants.iconEnvelope,
                onPressed: () {
                  print('thanks for pressing'); // ignore: avoid_print
                },
              ),
            ],
          ),
        ),
      );
}
