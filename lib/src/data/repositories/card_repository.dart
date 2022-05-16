import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/card_action.dart';
import 'package:rescado/src/data/models/card_filter.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/services/providers/api_client.dart';
import 'package:rescado/src/utils/logger.dart';

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => ApiCardRepository(ref.read),
);

// All API endpoints regarding cards.
abstract class CardRepository {
  Future<List<Animal>> generate({required CardFilter cardFilter});

  Future<List<Like>> getLiked();

  Future<CardAction> addLiked({required List<Animal> animals});

  Future<CardAction> deleteLiked({required List<Animal> animals});

  Future<CardAction> addSkipped({required List<Animal> animals});

  Future<void> deleteSkipped();
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

  // region liked

  @override
  Future<List<Like>> getLiked() async {
    _logger.d('getLiked()');

    final endpoint = Uri.parse('${RescadoConstants.api}/cards/liked?detailed=true');

    final response = List<Map<String, dynamic>>.from(await _read(apiClientProvider).getJson(
      endpoint,
    ) as List);

    return response.map((like) => Like.fromJson(like)).toList();
  }

  @override
  Future<CardAction> addLiked({required List<Animal> animals}) async {
    _logger.d('addLiked()');

    final endpoint = Uri.parse('${RescadoConstants.api}/cards/liked');

    final response = await _read(apiClientProvider).postJson(
      endpoint,
      body: jsonEncode({
        'ids': animals.map((animal) => animal.id).toList(),
      }),
    ) as Map<String, dynamic>;

    return CardAction.fromJsonWithAnimalData(response, animals);
  }

  @override
  Future<CardAction> deleteLiked({required List<Animal> animals}) async {
    _logger.d('deleteLiked()');

    final endpoint = Uri.parse('${RescadoConstants.api}/cards/liked');

    final response = await _read(apiClientProvider).deleteJson(
      endpoint,
      body: jsonEncode({
        'ids': animals.map((animal) => animal.id).toList(),
      }),
    ) as Map<String, dynamic>;

    return CardAction.fromJsonWithAnimalData(response, animals);
  }

  // endregion
  // region skipped

  @override
  Future<CardAction> addSkipped({required List<Animal> animals}) async {
    _logger.d('addSkipped()');

    final endpoint = Uri.parse('${RescadoConstants.api}/cards/skipped');

    final response = await _read(apiClientProvider).postJson(
      endpoint,
      body: jsonEncode({
        'ids': animals.map((animal) => animal.id).toList(),
      }),
    ) as Map<String, dynamic>;

    return CardAction.fromJsonWithAnimalData(response, animals);
  }

  @override
  Future<void> deleteSkipped() async {
    _logger.d('deleteSkipped()');

    final endpoint = Uri.parse('${RescadoConstants.api}/cards/skipped');

    await _read(apiClientProvider).deleteJson(
      endpoint,
    );
  }

// endregion
}
