import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/services/controllers/main_tab_controller.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/buttons/action_button.dart';
import 'package:rescado/src/views/containers/full_page.dart';
import 'package:rescado/src/views/swipe_view.dart';

// Placeholder view.
class ProfileView extends StatelessWidget {
  static const viewId = 'ProfileView';
  static const tabIndex = 2;

  const ProfileView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FullPage(
        title: context.i10n.labelProfile,
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 500.0),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return ActionButton(
                    label: 'Swipe time!',
                    svgAsset: RescadoConstants.iconRefresh,
                    onPressed: () => ref.watch(tabControllerProvider.notifier).setActiveTab(SwipeView.tabIndex),
                  );
                },
              ),
              const Text('Placeholder ProfileView'),
              const SizedBox(height: 500.0),
            ],
          ),
        ),
      );
}
