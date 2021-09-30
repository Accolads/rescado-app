import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:rescado/src/widgets/page_title.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            PageTitle(
              label: AppLocalizations.of(context)!.tabbarProfile,
            ),
          ],
        ),
      ),
    );
  }
}
