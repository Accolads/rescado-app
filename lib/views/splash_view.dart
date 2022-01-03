import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/constants/rescado_style.dart';
import 'package:rescado/controllers/user_controller.dart';
import 'package:rescado/models/user.dart';
import 'package:rescado/views/buttons/action_button.dart';
import 'package:rescado/views/cards/action_card.dart';
import 'package:rescado/views/main_view.dart';

// Initial view to take care of authentication. Shows a loading animation and handles authentication errors.
class SplashView extends StatefulWidget {
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
              child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                // TODO WIP
                return ref.watch(userControllerProvider).when(
                  data: (User user) {
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const MainView(),
                      ),
                    );
                    return const SizedBox(height: 1.0);
                  },
                  error: (Object error, StackTrace? stackTrace) {
                    _animationController.reset();
                    return ActionCard(
                      title: 'error occurred',
                      body: 'dayum ngl this kinda sucks',
                      animated: true,
                      svgAsset: RescadoStyle.illustrationWomanWithWrench,
                      actionButton: ActionButton(
                        label: 'Try again',
                        svgAsset: RescadoStyle.iconRefresh,
                        onPressed: () {
                          print('trigger retry in controller pls'); //ignore: avoid_print
                        },
                      ),
                    );
                  },
                  loading: () {
                    _animationController.repeat(reverse: true);
                    return const SizedBox(height: 1.0);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
