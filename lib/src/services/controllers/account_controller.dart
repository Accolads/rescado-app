import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/data/repositories/account_repository.dart';
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

    final profile = await _read(accountRepositoryProvider).get();
    if (profile.avatar == null) {
      _logger.i('Uploading a dummy profile picture');

      _read(remoteStorageProvider).uploadAvatar();
      // TODO update account
    }
    state = AsyncData(profile);
  }

  void upload() async {
    _logger.d('getAccountDetails()');

    state = AsyncData(await _read(accountRepositoryProvider).get());
  }
}
