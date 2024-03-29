import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/data/models/authentication.dart';
import 'package:rescado/src/data/repositories/authentication_repository.dart';
import 'package:rescado/src/exceptions/api_exception.dart';
import 'package:rescado/src/services/controllers/account_controller.dart';
import 'package:rescado/src/services/providers/device_storage.dart';
import 'package:rescado/src/utils/logger.dart';

final authenticationControllerProvider = StateNotifierProvider<AuthenticationController, AsyncValue<Authentication>>(
  (ref) => AuthenticationController(ref.read).._initialize(),
);

class AuthenticationController extends StateNotifier<AsyncValue<Authentication>> {
  static final _logger = addLogger('AuthenticationController');

  final Reader _read;

  AuthenticationController(this._read) : super(const AsyncLoading());

  void _initialize() async {
    _logger.d('initialize()');

    // Handle authentication as soon as this controller is loaded.
    renewSession();
  }

  Future<void> login({required String email, required String password}) async {
    _logger.d('login()');

    final authentication = await _read(authenticationRepositoryProvider).login(email: email, password: password);

    await _read(accountControllerProvider.notifier).getAccount();
    state = AsyncData(authentication);
  }

  Future<void> logout() async {
    _logger.d('logout()');

    await _read(authenticationRepositoryProvider).logout();
    _read(accountControllerProvider.notifier).unsetAccount();
    state = AsyncData(Authentication.loggedOut());
  }

  // Will attempt to create if necessary, refresh if possible, or recover a dead session if the user was anonymous. Fetches account details if applicable.
  Future<void> renewSession() async {
    _logger.d('renewSession()');
    state = const AsyncLoading();

    try {
      final token = await _read(deviceStorageProvider).getToken();

      if (token == null) {
        // TODO Do we want to consider, in the future, offering the user the option to log in before automatically creating an account?
        _logger.i('Creating a new account for a first-time user.');
        final authentication = await _read(authenticationRepositoryProvider).register();

        _logger.i('User registration was successful.');
        state = AsyncData(authentication);
        return;
      }

      try {
        _logger.i('Attempting to refresh the session using the refresh token in the JWT.');
        final authentication = await _read(authenticationRepositoryProvider).refresh();

        _logger.i('Session renewal was successful.');
        state = AsyncData(authentication);

        final token = await _read(deviceStorageProvider).getToken();
        FirebaseCrashlytics.instance.setUserIdentifier(token!.subject);
      } on ApiException catch (exception) {
        if (exception.keys.first == 'TokenExpired') {
          _logger.w('The session is expired.');

          if (token.status == AccountStatus.anonymous) {
            _logger.i('User was anonymous. Attempting to recover the session with our UUID.');
            await _read(authenticationRepositoryProvider).recover();
          } else {
            _logger.i('User was not anonymous. Will need to log in manually to continue.');
            state = AsyncData(Authentication.expired());
            return;
          }
        } else {
          // The only other ApiException is a TokenMismatch. That can technically never happen in the app (I think) but we'll throw it again just in case.
          rethrow;
        }
      }
    } catch (error, stackTrace) {
      // This is purely UX. Hitting the retry button must make it look like something is happening too, even if the result is instant.
      await Future<dynamic>.delayed(const Duration(milliseconds: 3333));

      _logger.e('Session renewal failed.', error, stackTrace);
      state = AsyncError(error);
    }
  }
}
