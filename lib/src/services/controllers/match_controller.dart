import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/data/models/membership.dart';
import 'package:rescado/src/data/repositories/group_repository.dart';
import 'package:rescado/src/services/controllers/account_controller.dart';
import 'package:rescado/src/utils/logger.dart';

final matchControllerProvider = StateNotifierProvider<MatchController, AsyncValue<List<Like>>>(
  (ref) => MatchController(ref.read).._initialize(),
);

class MatchController extends StateNotifier<AsyncValue<List<Like>>> {
  static final _logger = addLogger('MatchController');

  final Reader _read;

  MatchController(this._read) : super(const AsyncValue.loading());

  void _initialize() async {
    _logger.d('initialize()');
    state = const AsyncValue.loading();

    fetchMatches();
  }

  Future<void> fetchMatches() async {
    _logger.d('fetchMatches()');

    final confirmedGroup = _read(accountControllerProvider).value?.groups.where((group) => group.status == MembershipStatus.confirmed).firstOrNull;

    state = AsyncValue.data(
      confirmedGroup == null ? [] : await _read(groupRepositoryProvider).getMatches(),
    );
  }

  void removeAnimal(Animal animal) {
    _logger.d('removeAnimal()');

    state = AsyncValue.data(
      state.value!.where((like) => like.animal != animal).toList(),
    );
  }
}
