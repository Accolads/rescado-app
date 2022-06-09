import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/exceptions/api_exception.dart';
import 'package:rescado/src/services/controllers/account_controller.dart';
import 'package:rescado/src/services/controllers/authentication_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/utils/extensions.dart';
import 'package:rescado/src/views/buttons/action_button.dart';
import 'package:rescado/src/views/buttons/appbar_button.dart';
import 'package:rescado/src/views/main_view.dart';
import 'package:rescado/src/views/misc/circle_tab_indicator.dart';

//TODO should this move to RescadoConstants?
const blankEmail = 'blankEmail';
const blankPassword = 'blankPassword';
const credentialsMismatch = 'credentialsMismatch';
const invalidEmail = 'invalidEmail';
const shortPassword = 'shortPassword';
const stupidPassword = 'stupidPassword';

class AuthenticationView extends ConsumerStatefulWidget {
  static const viewId = 'AuthenticationView';

  const AuthenticationView({Key? key}) : super(key: key);

  @override
  AuthenticationViewState createState() => AuthenticationViewState();
}

class AuthenticationViewState extends ConsumerState<AuthenticationView> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
  List<String> _loginErrors = [];
  List<String> _registerErrors = [];

  void navigate() {
    final NavigatorState? navigator = Navigator.maybeOf(context);
    if (navigator != null && navigator.canPop()) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, MainView.viewId, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ref.watch(settingsControllerProvider).activeTheme.backgroundColor, // required for clean Hero animation and bottom overflow on iOS
        resizeToAvoidBottomInset: true,
        body: DefaultTabController(
          length: 2,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: ref.watch(settingsControllerProvider).activeTheme.backgroundColor,
                stretch: true,
                pinned: false,
                expandedHeight: MediaQuery.of(context).size.height / 3,
                leadingWidth: 66,
                leading: ref.read(accountControllerProvider).value?.status == AccountStatus.anonymous
                    ? AppBarButton(
                        semanticsLabel: context.i10n.labelBack,
                        svgAsset: RescadoConstants.iconChevronLeft,
                        opaque: true,
                        onPressed: () => Navigator.pop(context),
                      )
                    : const SizedBox(),
                flexibleSpace: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        RescadoConstants.imageAuthenticationBanner,
                        fit: BoxFit.cover,
                        color: ref.read(settingsControllerProvider).activeTheme.accentColor.withOpacity(0.6),
                        colorBlendMode: BlendMode.lighten,
                      ),
                    ),
                    Positioned(
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: ref.watch(settingsControllerProvider).activeTheme.backgroundColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      bottom: -1,
                      left: 0,
                      right: 0,
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    color: ref.watch(settingsControllerProvider).activeTheme.backgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: ref.watch(settingsControllerProvider).activeTheme.borderColor,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.i10n.labelSignUp,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TabBar(
                        indicator: CircleTabIndicator(
                          color: ref.watch(settingsControllerProvider).activeTheme.accentColor,
                        ),
                        tabs: [
                          Tab(
                            text: context.i10n.labelSignIn,
                          ),
                          Tab(
                            text: context.i10n.labelRegister,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 34.0),
                  child: TabBarView(
                    children: [
                      _buildLogin(
                        context: context,
                        ref: ref,
                      ),
                      _buildRegister(
                        context: context,
                        ref: ref,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  Widget _buildLogin({required BuildContext context, required WidgetRef ref}) => Form(
        key: _loginFormKey,
        child: Column(
          children: [
            _buildTextField(
              label: context.i10n.labelEmailAddress,
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
              validator: (email) => !RegExp(RescadoConstants.emailValidatorRegex).hasMatch(email!) || _loginErrors.contains(invalidEmail) || _loginErrors.contains(blankEmail) ? context.i10n.messageInvalidEmailAddress : null,
            ),
            _buildTextField(
              label: context.i10n.labelPassword,
              controller: _passwordController,
              obscureText: !_passwordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 14.0,
                ),
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
              ),
              validator: (password) {
                if (password == null || password.isEmpty || _loginErrors.contains(blankPassword)) {
                  return context.i10n.messageEmptyPassword;
                } else if (_loginErrors.contains(credentialsMismatch)) {
                  return context.i10n.messageCredentialsMismatch;
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(ref.read(settingsControllerProvider).activeTheme.accentColor),
                    ),
                    child: Text(
                      context.i10n.labelForgotPassword,
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    // TODO implement onPressed()
                    onPressed: () => print('NOT IMPLEMENTED'), // ignore: avoid_print
                  ),
                  ActionButton(
                    label: context.i10n.labelSignIn,
                    svgAsset: RescadoConstants.iconKey,
                    onPressed: () {
                      setState(() => _loginErrors = []);
                      if (_loginFormKey.currentState!.validate()) {
                        ref
                            .read(authenticationControllerProvider.notifier)
                            .login(
                              email: _emailController.text,
                              password: _passwordController.text,
                            )
                            .then((_) => navigate())
                            .onError(
                              (ApiException apiException, _) => setState(() => _loginErrors = apiException.keys),
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildRegister({required BuildContext context, required WidgetRef ref}) => Form(
        key: _registerFormKey,
        child: Column(
          children: [
            _buildTextField(
              label: context.i10n.labelEmailAddress,
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
              validator: (email) => !RegExp(RescadoConstants.emailValidatorRegex).hasMatch(email!) || _registerErrors.contains(blankEmail) ? context.i10n.messageInvalidEmailAddress : null,
            ),
            _buildTextField(
                label: context.i10n.labelPassword,
                controller: _passwordController,
                obscureText: !_passwordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 14.0,
                  ),
                  onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                ),
                validator: (password) {
                  if (password == null || password.length < 8 || _registerErrors.contains(shortPassword)) {
                    return context.i10n.messageInvalidPassword;
                  } else if (_registerErrors.contains(stupidPassword)) {
                    return context.i10n.messageStupidPassword;
                  }
                  return null;
                }),
            _buildTextField(
              label: context.i10n.labelName,
              controller: _nameController,
              validator: (name) => name == null || name.length < 2 ? context.i10n.messageInvalidName : null,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ActionButton(
                    label: context.i10n.labelRegister,
                    svgAsset: RescadoConstants.iconKey,
                    onPressed: () async {
                      setState(() => _registerErrors = []);
                      if (_registerFormKey.currentState!.validate()) {
                        await ref
                            .watch(accountControllerProvider.notifier)
                            .patchAccount(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _nameController.text,
                            )
                            //TODO What with server errors?
                            .then((_) => navigate())
                            .onError(
                              (ApiException apiException, _) => setState(() => _registerErrors = apiException.keys),
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildTextField({required String label, required TextEditingController controller, TextInputType textInputType = TextInputType.text, bool obscureText = false, IconButton? suffixIcon, String? Function(String?)? validator}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: textInputType,
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
              suffixIcon: suffixIcon),
          validator: validator,
        ),
      );
}
