import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/group.dart';
import 'package:rescado/src/data/models/like.dart';
import 'package:rescado/src/services/providers/api_client.dart';
import 'package:rescado/src/utils/logger.dart';

final groupRepositoryProvider = Provider<GroupRepository>(
  (ref) => ApiGroupRepository(ref.read),
);

// All API endpoints regarding group.
abstract class GroupRepository {
  Future<List<Like>> getMatches();
  
}

class ApiGroupRepository implements GroupRepository {
  static final _logger = addLogger('ApiGroupRepository');

  final Reader _read;

  ApiGroupRepository(this._read);

  @override
  Future<List<Like>> getMatches() async {
    _logger.d('getMatches()');

    final endpoint = Uri.parse('${RescadoConstants.api}/group/liked?detailed=true');

    final response = List<Map<String, dynamic>>.from(await _read(apiClientProvider).getJson(
      endpoint,
    ) as List);

    return response.map((like) => Like.fromJson(like)).toList();
  }
}
