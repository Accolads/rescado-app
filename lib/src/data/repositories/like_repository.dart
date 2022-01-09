import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/data/models/like_action.dart';
import 'package:rescado/src/services/providers/api_client.dart';
import 'package:rescado/src/utils/logger.dart';

final likeRepositoryProvider = Provider<LikeRepository>(
  (ref) => ApiLikeRepository(ref.read),
);

// All API endpoints regarding likes.
abstract class LikeRepository {
  Future<List<Like>> getAllLikes();

  Future<LikeAction> addLikes({required List<Animal> animals});
  
  Future<LikeAction> deleteLikes({required List<Animal> animals});
}

class ApiLikeRepository implements LikeRepository {
  static final _logger = addLogger('ApiLikeRepository');

  final Reader _read;

  ApiLikeRepository(this._read);

  @override
  Future<List<Like>> getAllLikes() async {
    _logger.d('getAllLikes()');

    final endpoint = Uri.parse('${RescadoConstants.api}/likes?detailed=true');

    final response = await _read(apiClientProvider).getJson(
      endpoint,
    ) as List<Map<String, dynamic>>;

    return response.map((like) => Like.fromJson(like)).toList();
  }

  @override
  Future<LikeAction> addLikes({required List<Animal> animals}) async {
    _logger.d('addLikes()');

    final endpoint = Uri.parse('${RescadoConstants.api}/likes');

    final response = await _read(apiClientProvider).postJson(
      endpoint,
      body: jsonEncode({
        'ids': animals.map((animal) => animal.id),
      }),
    ) as Map<String, dynamic>;

    return LikeAction.fromJsonWithAnimalData(response, animals);
  }

  @override
  Future<LikeAction> deleteLikes({required List<Animal> animals}) async {
    _logger.d('deleteLikes()');

    final endpoint = Uri.parse('${RescadoConstants.api}/likes');

    final response = await _read(apiClientProvider).deleteJson(
      endpoint,
      body: jsonEncode({
        'ids': animals.map((animal) => animal.id),
      }),
    ) as Map<String, dynamic>;

    return LikeAction.fromJsonWithAnimalData(response, animals);
  }
}
