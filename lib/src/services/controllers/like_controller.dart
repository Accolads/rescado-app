import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/data/repositories/card_repository.dart';
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

  void like(Animal animal) {
    _read(cardRepositoryProvider).addLiked(animals: [animal]);
  }

  void skip() {
    // opslaan in tijdelijke lijst en
  }

  Future<void> fetchLikes() async {
    _logger.i('Fetching the likes of the current user.');
    final likes = await _read(cardRepositoryProvider).getLiked();

    state = AsyncValue.data(likes);
  }

  void deleteLike(Like like) async {
    final cardAction = await _read(cardRepositoryProvider).deleteLiked(animals: [like.animal]);

    if (cardAction.liked != null && cardAction.liked!.contains(like.animal)) {
      state.value?.removeWhere((apiLike) => apiLike.animal.id == like.animal.id);
      state = AsyncValue.data(state.value!.toList());
    }
  }
}
