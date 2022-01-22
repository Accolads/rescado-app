import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/data/repositories/like_repository.dart';
import 'package:rescado/src/utils/logger.dart';

final likeControllerProvider = StateNotifierProvider<LikeController, AsyncValue<List<Like>>>(
  (ref) => LikeController(ref.read).._initialize(),
);

class LikeController extends StateNotifier<AsyncValue<List<Like>>> {
  static final _logger = addLogger('LikeController');

  final Reader _read;

  LikeController(this._read) : super(const AsyncValue.loading());

  void _initialize() async {
    _logger.d('initialize()');
    state = const AsyncValue.loading();

    fetchLikes();
  }

  void fetchLikes() async {
    _logger.i('Fetching the likes of the current user.');
    final likes = await _read(likeRepositoryProvider).getAllLikes();

    state = AsyncValue.data(likes);
  }
}
