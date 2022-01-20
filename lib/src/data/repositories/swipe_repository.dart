import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/services/providers/api_client.dart';
import 'package:rescado/src/utils/logger.dart';

final swipeRepositoryProvider = Provider<SwipeRepository>(
  (ref) => ApiSwipeRepository(ref.read),
);

// All API endpoints regarding swipes.
abstract class SwipeRepository {
  Future<Animal> generate({required int number, required List<AnimalKind> kinds, required List<AnimalSex> sexes, required int minimumAge, required int maximumAge, required int minimumWeight, required int maximumWeight, required bool vaccinated, required bool sterilized});

  Future<void> reset();
}

class ApiSwipeRepository implements SwipeRepository {
  static final _logger = addLogger('ApiSwipeRepository');

  final Reader _read;

  ApiSwipeRepository(this._read);

  @override
  Future<Animal> generate({required int number, required List<AnimalKind> kinds, required List<AnimalSex> sexes, required int minimumAge, required int maximumAge, required int minimumWeight, required int maximumWeight, required bool vaccinated, required bool sterilized}) async {
    _logger.d('generate()');

    final endpoint = Uri.parse('${RescadoConstants.api}/cards/generate');

    final response = await _read(apiClientProvider).postJson(
      endpoint,
      body: jsonEncode({
        'number': number,
        'kinds': kinds.map((kind) => kind.name),
        'sexes': sexes.map((sex) => sex.name),
        'minimumAge': minimumAge,
        'maximumAge': maximumAge,
        'minimumWeight': minimumWeight,
        'maximumWeight': maximumWeight,
        'vaccinated': vaccinated,
        'sterilized': sterilized,
      }),
    ) as Map<String, dynamic>;

    return Animal.fromJson(response);
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
