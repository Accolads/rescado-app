import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/card_filter.dart';
import 'package:rescado/src/services/providers/api_client.dart';
import 'package:rescado/src/utils/logger.dart';

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => ApiCardRepository(ref.read),
);

// All API endpoints regarding cards.
abstract class CardRepository {
  Future<List<Animal>> generate({required CardFilter cardFilter});

  Future<void> reset();
}

class ApiCardRepository implements CardRepository {
  static final _logger = addLogger('ApiCardRepository');

  final Reader _read;

  ApiCardRepository(this._read);

  @override
  Future<List<Animal>> generate({required CardFilter cardFilter}) async {
    _logger.d('generate()');

    final endpoint = Uri.parse('${RescadoConstants.api}/cards/generate');

    final response = List<Map<String, dynamic>>.from(await _read(apiClientProvider).postJson(
      endpoint,
      body: cardFilter.toJson(),
    ) as List);

    return response.map((animal) => Animal.fromJson(animal)).toList();
  }

  @override
  Future<void> reset() async {
    _logger.d('reset()');

    final endpoint = Uri.parse('${RescadoConstants.api}/cards/reset');

    await _read(apiClientProvider).postJson(
      endpoint,
    );
  }
}
