import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rescado/views/containers/full_page.dart';

// Placeholder view.
class ProfileView extends StatelessWidget {
  static const viewId = 'ProfileView';

  const ProfileView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FullPage(
        title: AppLocalizations.of(context)!.labelProfile,
        body: Center(
          child: Column(
            children: const <Widget>[
              SizedBox(height: 500.0),
              Text('Placeholder ProfileView'),
              SizedBox(height: 500.0),
            ],
          ),
        ),
      );
}
