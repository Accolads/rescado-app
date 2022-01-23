import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/data/models/card_filter.dart';

final filterControllerProvider = StateNotifierProvider<FilterController, CardFilter>(
  (ref) => FilterController(),
);

class FilterController extends StateNotifier<CardFilter> {
  // static final _logger = addLogger('FilterController');

  FilterController() : super(CardFilter());
}
