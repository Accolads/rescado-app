import 'dart:convert';
import 'package:http/http.dart';
import 'package:rescado/src/models/animal_model.dart';

import 'package:rescado/src/services/api_client.dart';

class LikeService {
  static void processSwipe(int animalId) async {
    // ignore: avoid_print
    print('Animal $animalId liked');
    Response response = await ApiClient().post(
      Uri.parse('${ApiClient.host}/api/likes'),
      body: jsonEncode(<String, List<int>>{
        'ids': <int>[animalId]
      }),
    );

    if (response.statusCode != 200) throw Exception('Failed liking animal');
  }

  static Future<List<AnimalModel>> getLikedAnimals() async {
    Response response = await ApiClient().get(Uri.parse('${ApiClient.host}/api/likes?detailed=true'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).map((dynamic data) => AnimalModel.fromJson(data['animal'] as Map<String, dynamic>, DateTime.now())).toList();
    } else {
      throw Exception('Failed fetching animals ${response.body}');
    }
  }
}
