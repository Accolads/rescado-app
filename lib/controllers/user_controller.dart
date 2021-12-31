import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/models/user.dart';

final userControllerProvider = StateNotifierProvider<UserController, AsyncValue<User?>>(
  (ref) => UserController(ref.read).._initialize(),
);

class UserController extends StateNotifier<AsyncValue<User?>> {
  final Reader _read;

  UserController(this._read) : super(const AsyncValue.loading());

  void _initialize() async {
    // TODO write app-start logic (checking token, registering or refreshing/recovering, create instance of User)
    state = const AsyncValue.loading();
  }
}
