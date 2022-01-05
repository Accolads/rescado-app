import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rescado/views/containers/full_page.dart';

// Placeholder view.
class DiscoverView extends StatelessWidget {
  static const viewId = 'DiscoverView';

  const DiscoverView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FullPage(
        title: AppLocalizations.of(context)!.labelDiscover,
        body: const Center(
          child: Text(
            'Placeholder DiscoverView',
          ),
        ),
      );
}
