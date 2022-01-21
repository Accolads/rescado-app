import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/carddata.dart';
import 'package:rescado/src/services/providers/api_client.dart';
import 'package:rescado/src/utils/logger.dart';

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => ApiCardRepository(ref.read),
);

// All API endpoints regarding cards.
abstract class CardRepository {
  Future<List<Animal>> generate({required CardData cardData});

  Future<void> reset();
}

class ApiCardRepository implements CardRepository {
  static final _logger = addLogger('ApiCardRepository');

  final Reader _read;

  ApiCardRepository(this._read);

  @override
  Future<List<Animal>> generate({required CardData cardData}) async {
    _logger.d('generate()');

    final endpoint = Uri.parse('${RescadoConstants.api}/cards/generate');

    final response = await _read(apiClientProvider).postJson(
      endpoint,
      body: jsonEncode(cardData),
    ) as List<Map<String, dynamic>>;

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
