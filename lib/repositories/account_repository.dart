import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/constants/rescado_constants.dart';
import 'package:rescado/models/api_account.dart';
import 'package:rescado/providers/api_client.dart';
import 'package:rescado/utils/logger.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => ApiAccountRepository(ref.read),
);

// All API endpoints regarding account.
abstract class AccountRepository {
  Future<ApiAccount> getAccount();

  Future<ApiAccount> patchAccount({required String name, required String email, required String password, required String avatar});
}

class ApiAccountRepository implements AccountRepository {
  static final _logger = addLogger('ApiAccountRepository');

  final Reader _read;

  ApiAccountRepository(this._read);

  @override
  Future<ApiAccount> getAccount() async {
    _logger.d('getAccount()');

    final endpoint = Uri.parse('${RescadoConstants.api}/account');

    final response = await _read(apiClientProvider).getJson(
      endpoint,
    );

    return ApiAccount.fromJson(response);
  }

  @override
  Future<ApiAccount> patchAccount({required String name, required String email, required String password, required String avatar}) {
    // TODO: implement patchAccount
    throw UnimplementedError();
  }
}
