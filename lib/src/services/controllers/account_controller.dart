import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/data/models/authentication.dart';
import 'package:rescado/src/data/models/image.dart';
import 'package:rescado/src/data/repositories/account_repository.dart';
import 'package:rescado/src/services/controllers/authentication_controller.dart';
import 'package:rescado/src/services/providers/remote_storage.dart';
import 'package:rescado/src/utils/logger.dart';

final accountControllerProvider = StateNotifierProvider<AccountController, AsyncValue<Account>>(
  (ref) => AccountController(ref.read).._initialize(),
);

class AccountController extends StateNotifier<AsyncValue<Account>> {
  static final _logger = addLogger('AccountController');

  final Reader _read;

  AccountController(this._read) : super(const AsyncLoading());

  void _initialize() async {
    _logger.d('initialize()');

    var account = await _read(accountRepositoryProvider).get();

    if (account.avatar == null) {
      // TODO move this to the backend?
      final avatar = Image.fromFirebase(
        type: ImageType.avatar,
        url: await _read(remoteStorageProvider).uploadAvatar(),
      );

      account = await _read(accountRepositoryProvider).patch(
        account: account.copyWith(avatar: avatar),
      );
    }
    state = AsyncData(account);
  }

  Future<void> getAccount() async {
    _logger.d('getAccount()');

    var account = await _read(accountRepositoryProvider).get();
    state = AsyncData(account);
  }

  Future<void> patchAccount({required String email, String? password, required String name}) async {
    _logger.d('patchAccount()');

    if (_read(authenticationControllerProvider).value?.status == AuthenticationStatus.loggedOut) {
      await _read(authenticationControllerProvider.notifier).renewSession();
      await getAccount();
    }

    final account = await _read(accountRepositoryProvider).patch(
      account: state.value!.copyWith(
        email: email,
        name: name,
      ),
      password: password,
    );

    state = AsyncData(account);
  }

  void unsetAccount() {
    _logger.d('unsetAccount()');
    state = const AsyncLoading();
  }
}
