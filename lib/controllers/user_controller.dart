import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/constants/rescado_storage.dart';
import 'package:rescado/exceptions/api_exception.dart';
import 'package:rescado/models/api_authentication.dart';
import 'package:rescado/models/user.dart';
import 'package:rescado/repositories/authentication_repository.dart';
import 'package:rescado/utils/logger.dart';

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

    // TODO write app-start logic (checking token, registering or refreshing/recovering, create instance of User). I've already started below.

    // If we have no token, this is first-time user... and we should present the option to log in (instead of auto registering new account?)
    if ((await RescadoStorage.getToken()).contains('no-token')) {
      state = AsyncValue.data(User(status: UserStatus.newbie));
      return;
    }

    // If we get a token, we should always attempt to refresh the session first.
    try {
      await _read(authenticationRepositoryProvider).refresh(); // do something with the returned ApiAuthentication...
    } on ApiException catch (error) {
      state = AsyncError(error.messages.first);
      // We should handle this properly. First message will start with something like "[expiredToken]" indicating what to do in the UI.
      // If expired, we should also check the token to see if it's anonymous, and if so try recover()ing the session before setting an AsyncError.
      // Also: AsyncError should always be last resort and is not necessary if expired. Just put a user with status UserStatus.expired in the state and handle in the UI.
      return;
    }
    // catch more like ServerException and OfflineException...
  }

  void registerNewUser() async {
    state = const AsyncValue.loading();

    // Just a showcase method for now <3
    var authentication = await _read(authenticationRepositoryProvider).register(); // try-catch...
    if (authentication.status != AuthenticationStatus.anonymous) {
      _logger.e('simply impossible to get here ✌️');
      return;
    }
    state = AsyncValue.data(User(status: UserStatus.anonymous));
  }
}
