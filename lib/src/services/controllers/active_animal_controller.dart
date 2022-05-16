import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/active_animal.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/utils/logger.dart';

final activeAnimalControllerProvider = StateNotifierProvider<ActiveAnimalController, AsyncValue<ActiveAnimal>>(
  (_) => ActiveAnimalController(),
);

class ActiveAnimalController extends StateNotifier<AsyncValue<ActiveAnimal>> {
  static final _logger = addLogger('ActiveAnimalController');

  ActiveAnimalController() : super(const AsyncLoading());

  void updateActiveAnimal({required Animal animal, bool isLiked = false}) async {
    _logger.d('updateActiveAnimal()');
    state = AsyncData(ActiveAnimal(animal: animal, isLiked: isLiked));
  }
}
