import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/data/repositories/group_repository.dart';
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

    state = AsyncValue.data(
      await _read(groupRepositoryProvider).getMatches(),
    );
  }

  void deleteMatch(Like like) {
    _logger.d('deleteMatch()');

    if (state.value != null) {
      state.value!.removeWhere((apiLike) => apiLike.animal.id == like.animal.id);
      state = AsyncValue.data(state.value!.toList());
    }
  }
}
