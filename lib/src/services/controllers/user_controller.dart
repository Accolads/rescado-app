import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/data/models/user.dart';
import 'package:rescado/src/data/repositories/account_repository.dart';
import 'package:rescado/src/data/repositories/authentication_repository.dart';
import 'package:rescado/src/exceptions/api_exception.dart';
import 'package:rescado/src/services/providers/device_storage.dart';
import 'package:rescado/src/utils/logger.dart';
import 'package:rescado/src/utils/mapper.dart';

final userControllerProvider = StateNotifierProvider<UserController, AsyncValue<User>>(
  (ref) => UserController(ref.read).._initialize(),
);

class UserController extends StateNotifier<AsyncValue<User>> {
  static final _logger = addLogger('UserController');

  final Reader _read;

  UserController(this._read) : super(const AsyncValue.loading());

  void _initialize() async {
    _logger.d('initialize()');
    state = const AsyncValue.loading();

    // Handle authentication as soon as this controller is loaded.
    renewSession();
  }

  // Will attempt to create if necessary, refresh if possible, or recover a dead session if the user was anonymous. Fetches account details if applicable.
  void renewSession() async {
    _logger.d('renewSession()');
    state = const AsyncValue.loading();

    try {
      final token = await _read(deviceStorageProvider).getToken();

      if (token == null) {
        // TODO Do we want to consider, in the future, offering the user the option to log in before automatically creating an account?
        _logger.i('Creating a new account for a first-time user.');
        await _read(authenticationRepositoryProvider).register();

        _logger.i('User registration was successful.');
        state = AsyncValue.data(await _fetchUserData());
        return;
      }

      try {
        _logger.i('Attempting to refresh the session using the refresh token in the JWT.');
        await _read(authenticationRepositoryProvider).refresh();
      } on ApiException catch (exception) {
        if (exception.keys.first == 'TokenExpired') {
          _logger.w('The session is expired.');

          if (token.status == AccountStatus.anonymous) {
            _logger.i('User was anonymous. Attempting to recover the session with our UUID.');
            await _read(authenticationRepositoryProvider).recover();
          } else {
            _logger.i('User was not anonymous. Will need to log in manually to continue.');
            state = AsyncValue.data(User(status: UserStatus.expired));
            return;
          }
        } else {
          // The only other ApiException is a TokenMismatch. That can technically never happen in the app (I think) but we'll throw it again just in case.
          rethrow;
        }
      }

      _logger.i('Session renewal was successful.');
      state = AsyncValue.data(await _fetchUserData());
    } catch (error, stackTrace) {
      // This is purely UX. Hitting the retry button must make it look like something is happening too, even if the result is instant.
      await Future<dynamic>.delayed(const Duration(milliseconds: 4444));

      _logger.e('Session renewal failed.', error, stackTrace);
      state = AsyncValue.error(error);
    }
  }

  Future<User> _fetchUserData() async {
    _logger.i('Fetching the current user\'s account data.');
    final accountData = await _read(accountRepositoryProvider).getAccount();

    return User(
      status: RescadoMapper.mapUserStatus(accountData.status),
      account: accountData,
    );
  }
}
