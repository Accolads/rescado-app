import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/data/repositories/card_repository.dart';
import 'package:rescado/src/services/controllers/match_controller.dart';
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

  Future<void> fetchLikes() async {
    _logger.d('fetchLikes()');

    state = AsyncValue.data(
      await _read(cardRepositoryProvider).getLiked(),
    );
  }

  void like(Animal animal) {
    _logger.d('like()');

    // TODO if liking/skipping fails, we should perhaps introduce a controller for an error UI or use main_tab_controller, and listen to it in MainView so we can eg. show a non-obtrusive toast or banner informing that something failed.
    _read(cardRepositoryProvider).addLiked(animals: [animal]);

    state.value!.add(Like.fromAnimal(animal));
  }

  void skip(Animal animal) {
    _logger.d('skip()');

    // TODO Same remark as above. This should not fail silently but let the user know.
    _read(cardRepositoryProvider).addSkipped(animals: [animal]);
  }

  void unlike(Like like) async {
    final cardAction = await _read(cardRepositoryProvider).deleteLiked(animals: [like.animal]);

    if (cardAction.liked != null && cardAction.liked!.contains(like.animal)) {
      state.value?.removeWhere((apiLike) => apiLike.animal.id == like.animal.id);
      _read(matchControllerProvider.notifier).deleteMatch(like);

      state = AsyncValue.data(state.value!.toList());
    }
  }
}
