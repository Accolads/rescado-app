import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/constants/rescado_style.dart';
import 'package:rescado/controllers/user_controller.dart';
import 'package:rescado/exceptions/offline_exception.dart';
import 'package:rescado/models/user.dart';
import 'package:rescado/views/authentication_view.dart';
import 'package:rescado/views/buttons/action_button.dart';
import 'package:rescado/views/containers/action_card.dart';
import 'package:rescado/views/main_view.dart';

// Initial view to take care of authentication. Shows a loading animation and handles authentication errors.
class SplashView extends StatefulWidget {
  static const viewId = 'SplashView';

  const SplashView({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (_, __) => SizedBox(
                  width: 125.0,
                  child: Stack(
                    children: <Widget>[
                      SvgPicture.asset('assets/logo/heart.svg'),
                      ...[1, 2, 3, 4].map((i) {
                        var value = _animationController.value * 50;
                        var y = (value > i * 10 && value < i * 10 + 10) ? value - i * 10 : 0.0;
                        // Not the animation I wanted but doesn't look too bad lol, so works for now ✌️
                        return Transform.translate(
                          offset: Offset(0, -y),
                          child: SvgPicture.asset('assets/logo/toe$i.svg'),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40.0,
              child: Consumer(
                builder: (_, WidgetRef ref, __) {
                  return ref.watch(userControllerProvider).when(
                      data: (User user) {
                        var nextViewId = (user.status == UserStatus.anonymous || user.status == UserStatus.identified) ? MainView.viewId : AuthenticationView.viewId;
                        // Future.delayed(Duration.zero) is a bit too hacky to my liking but we need to return a widget and using Navigator otherwise shortcuts the flow, resulting in errors.
                        Future.delayed(Duration.zero, () => Navigator.pushReplacementNamed(context, nextViewId));
                        return _buildPlaceholder();
                      },
                      error: (Object error, _) {
                        _animationController.reset();
                        final isOffline = error is OfflineException;

                        return ActionCard(
                          title: isOffline ? AppLocalizations.of(context)!.errorTitleAuthOffline : AppLocalizations.of(context)!.errorTitleAuthGeneric,
                          body: isOffline ? AppLocalizations.of(context)!.errorBodyAuthOffline : AppLocalizations.of(context)!.errorBodyAuthGeneric,
                          animated: true,
                          svgAsset: RescadoStyle.illustrationWomanWithWrench,
                          actionButton: ActionButton(
                            label: AppLocalizations.of(context)!.labelRetry,
                            svgAsset: RescadoStyle.iconRefresh,
                            onPressed: () {
                              ref.read(userControllerProvider.notifier).renewSession();
                            },
                          ),
                        );
                      },
                      loading: () => _buildPlaceholder());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    _animationController.repeat(reverse: true);
    return const SizedBox(height: 1.0);
  }
}
