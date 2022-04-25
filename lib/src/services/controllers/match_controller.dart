import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/data/repositories/group_repository.dart';
import 'package:rescado/src/utils/logger.dart';

final matchesControllerProvider = StateNotifierProvider<MatchesController, AsyncValue<List<Like>>>(
  (ref) => MatchesController(ref.read).._initialize(),
);

class MatchesController extends StateNotifier<AsyncValue<List<Like>>> {
  static final _logger = addLogger('MatchController');

  final Reader _read;

  MatchesController(this._read) : super(const AsyncValue.loading());

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
    state.value?.removeWhere((apiLike) => apiLike.animal.id == like.animal.id);
    state = AsyncValue.data(state.value!.toList());
  }
}
