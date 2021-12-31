import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rescado/src/ui/labels/page_title.dart';
import 'package:rescado/src/ui/views/profile/parts/likes_view.dart';
import 'package:rescado/src/util/logger.dart';

// Placeholder view. Will be completely replaced when implemented.
class ProfileView extends StatelessWidget {
  static const id = 'ProfileView';
  final logger = getLogger(id);

  ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('build()');
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            PageTitle(
              label: AppLocalizations.of(context)!.tabbarProfile,
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, LikesView.id),
              child: const Text('Bekijk likes'),
            )
          ],
        ),
      ),
    );
  }
}
