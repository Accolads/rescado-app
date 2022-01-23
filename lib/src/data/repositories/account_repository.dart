import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/account.dart';
import 'package:rescado/src/services/providers/api_client.dart';
import 'package:rescado/src/utils/logger.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => ApiAccountRepository(ref.read),
);

// All API endpoints regarding account.
abstract class AccountRepository {
  Future<Account> get();

  Future<Account> patch({required String name, required String email, required String password, required String avatar});
}

class ApiAccountRepository implements AccountRepository {
  static final _logger = addLogger('ApiAccountRepository');

  final Reader _read;

  ApiAccountRepository(this._read);

  @override
  Future<Account> getAccount() async {
    _logger.d('getAccount()');

    final endpoint = Uri.parse('${RescadoConstants.api}/account');

    final response = await _read(apiClientProvider).getJson(
      endpoint,
    ) as Map<String, dynamic>;

    return Account.fromJson(response);
  }

  @override
  Future<Account> patchAccount({required String name, required String email, required String password, required String avatar}) {
    // TODO: implement patchAccount
    throw UnimplementedError();
  }
}
