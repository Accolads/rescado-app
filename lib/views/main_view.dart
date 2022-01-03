import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainView extends ConsumerWidget {
  static const viewId = 'MainView';

  const MainView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text( AppLocalizations.of(context)!.labelSex,
        style:const TextStyle(color: Colors.pink),
        ),
      ),
    );
  }
}
