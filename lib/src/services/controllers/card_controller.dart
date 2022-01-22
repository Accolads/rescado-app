import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/carddata.dart';
import 'package:rescado/src/data/repositories/card_repository.dart';
import 'package:rescado/src/utils/logger.dart';

final cardControllerProvider = StateNotifierProvider<CardController, AsyncValue<CardData>>(
  (ref) => CardController(ref.read).._initialize(),
);

class CardController extends StateNotifier<AsyncValue<CardData>> {
  static final _logger = addLogger('CardController');

  final Reader _read;

  CardController(this._read) : super(const AsyncValue.loading());

  void _initialize() async {
    _logger.d('initialize()');
    state = const AsyncValue.loading();

    // Autofetch some cards when this controller is loaded

    final currentCardData = state.value ?? CardData(number: 5); // Initially only generate 5 cards, no filters
    final newCards = await _read(cardRepositoryProvider).generate(cardData: currentCardData);

    state = AsyncData(currentCardData.copyWith(
      cards: [...currentCardData.cards, ...newCards],
      number: 15,
    )); // Subsequent requests should generate 15 cards

    // TODO remove
    for (var element in state.value!.cards) {
      print(element.name);
    }
  }

  void nextCard({bool didLike = false}) async {
    _logger.d('nextCard()');

    final currentCardData = state.value!;
    // TODO api call or buffer?

    if (currentCardData.cards.length >= 5) {
      state = AsyncData(currentCardData.copyWith(
        cards: currentCardData.cards.sublist(1),
      ));
    } else {
      final newCards = await _read(cardRepositoryProvider).generate(cardData: currentCardData);
      state = AsyncData(currentCardData.copyWith(
        cards: [...currentCardData.cards.sublist(1), ...newCards],
      ));
    }
  }
}
