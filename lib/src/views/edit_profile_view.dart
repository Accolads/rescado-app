import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/services/controllers/account_controller.dart';
import 'package:rescado/src/services/controllers/authentication_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/authentication_view.dart';
import 'package:rescado/src/views/buttons/action_button.dart';
import 'package:rescado/src/views/buttons/appbar_button.dart';
import 'package:rescado/src/views/buttons/rounded_button.dart';
import 'package:rescado/src/views/misc/animated_logo.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static const viewId = 'EditProfileView';

  const EditProfileView({Key? key}) : super(key: key);

  @override
  EditProfileViewState createState() => EditProfileViewState();
}

class EditProfileViewState extends ConsumerState<EditProfileView> {
  final _headerHeight = 260.0; // Minimum height required for the header to show all its contents

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final preferredHeight = MediaQuery.of(context).size.height / 3;
    final actualHeight = preferredHeight < _headerHeight ? _headerHeight : preferredHeight;

    return ref.watch(accountControllerProvider).when(
          data: (Account account) {
            _nameController.text = account.name ?? '';
            _emailController.text = account.email ?? '';

            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: MediaQuery.of(context).size.height / 3,
                      leading: AppBarButton(
                        semanticsLabel: context.i10n.labelBack,
                        svgAsset: RescadoConstants.iconChevronLeft,
                        onPressed: () => Navigator.pop(context),
                      ),
                      actions: [
                        if (account.status == AccountStatus.enrolled)
                          TextButton(
                            child: Text(
                              "Save",
                              style: TextStyle(color: ref.watch(settingsControllerProvider).activeTheme.accentColor),
                            ),
                            onPressed: () {
                              ref.read(accountControllerProvider.notifier).patchAccount(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                  );
                            },
                          )
                      ],
                      flexibleSpace: LayoutBuilder(
                        builder: (_, BoxConstraints constraints) => Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            FlexibleSpaceBar(
                              background: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Transform.scale(
                                    scale: constraints.maxHeight / actualHeight,
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0),
                                          child: CircleAvatar(
                                            radius: 50.0,
                                            backgroundColor: ref.read(settingsControllerProvider).activeTheme.backgroundVariantColor,
                                            child: CircleAvatar(
                                              radius: 45.0,
                                              foregroundColor: ref.watch(settingsControllerProvider).activeTheme.primaryDimmedColor,
                                              foregroundImage: account.avatar == null ? null : NetworkImage(account.avatar!.reference),
                                              backgroundImage: AssetImage(RescadoConstants.imageDefaultProfilePicture),
                                            ),
                                          ),
                                        ),
                                        if (account.status == AccountStatus.enrolled)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 70.0),
                                            child: RoundedButton(
                                              semanticsLabel: context.i10n.labelAddFriend,
                                              svgAsset: RescadoConstants.iconEdit,
                                              onPressed: () => print('NOT IMPLEMENTED'), // ignore: avoid_print
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (account.status != AccountStatus.enrolled)
                      ..._buildPlaceholder(
                        label: 'Wil je alle features gebruiken van de app? Meld je dan aan.',
                        actionButton: ActionButton(
                          label: context.i10n.labelSignUp,
                          svgAsset: RescadoConstants.iconUser,
                          onPressed: () {
                            Navigator.pushNamed(context, AuthenticationView.viewId).then(
                              (_) => ref.read(accountControllerProvider.notifier).getAccount(),
                            );
                          },
                        ),
                        asset: RescadoConstants.illustrationTinyPeopleBigPhones,
                      ),
                    if (account.status == AccountStatus.enrolled)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            children: [
                              _buildTextField(
                                label: context.i10n.labelName,
                                controller: _nameController,
                              ),
                              _buildTextField(
                                label: context.i10n.labelEmailAddress,
                                controller: _emailController,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
                                  ),
                                  child: const Text('Logout'),
                                  onPressed: () => ref.read(authenticationControllerProvider.notifier).logout().then(
                                        (_) => Navigator.pushNamedAndRemoveUntil(context, AuthenticationView.viewId, (_) => false),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(
            child: SizedBox(
              width: 50.0,
              child: AnimatedLogo(),
            ),
          ),
          error: (_, __) => const Text('error!!'),
        );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ),
      );

  //TODO if this i gonna be the same as in profile view, this should be extracted to widget
  List<Widget> _buildPlaceholder({required String label, required ActionButton actionButton, required String asset}) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0, right: 30.0, bottom: 10.0, left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label),
                const SizedBox(height: 30.0),
                actionButton,
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          fillOverscroll: true,
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(
              asset,
              width: 220.0,
            ),
          ),
        ),
      ];
}
