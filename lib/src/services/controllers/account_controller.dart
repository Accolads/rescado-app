import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/data/repositories/account_repository.dart';
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
    state = const AsyncLoading();

    // We can fetch our own details as soon as this controller is loaded
    getAccountDetails();
  }

  void getAccountDetails() async {
    _logger.d('getAccountDetails()');

    state = AsyncData(await _read(accountRepositoryProvider).get());
  }
}
