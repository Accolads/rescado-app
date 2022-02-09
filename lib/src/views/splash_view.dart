import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/authentication.dart';
import 'package:rescado/src/exceptions/offline_exception.dart';
import 'package:rescado/src/services/controllers/authentication_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/authentication_view.dart';
import 'package:rescado/src/views/buttons/action_button.dart';
import 'package:rescado/src/views/containers/action_card.dart';
import 'package:rescado/src/views/main_view.dart';
import 'package:rescado/src/views/misc/animated_logo.dart';

// Initial view to take care of authentication. Shows a loading animation and handles authentication errors.
class SplashView extends ConsumerWidget {
  static const viewId = 'SplashView';

  const SplashView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: Container(
          width: double.infinity,
          color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              const SizedBox(
                width: 125.0,
                child: AnimatedLogo(),
              ),
              ref.watch(authenticationControllerProvider).when(
                    data: (authentication) {
                      var nextViewId = (authentication.status == AuthenticationStatus.anonymous || authentication.status == AuthenticationStatus.identified) ? MainView.viewId : AuthenticationView.viewId;
                      // Future.delayed(Duration.zero) is a bit too hacky to my liking but we need to return a widget and using Navigator otherwise shortcuts the flow, resulting in errors.
                      Future.delayed(Duration.zero, () => Navigator.pushReplacementNamed(context, nextViewId));
                      return const SizedBox.shrink();
                    },
                    error: (error, _) => ActionCard(
                      title: error is OfflineException ? context.i10n.errorTitleAuthOffline : context.i10n.errorTitleAuthGeneric,
                      body: error is OfflineException ? context.i10n.errorBodyAuthOffline : context.i10n.errorBodyAuthGeneric,
                      animated: true,
                      svgAsset: RescadoConstants.illustrationWomanWithWrench,
                      actionButton: ActionButton(
                        label: context.i10n.labelRetry,
                        svgAsset: RescadoConstants.iconRefresh,
                        onPressed: () => ref.read(authenticationControllerProvider.notifier).renewSession(),
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                  ),
            ],
          ),
        ),
      );
}
