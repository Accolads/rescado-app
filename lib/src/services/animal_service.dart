import 'dart:convert';

import 'package:http/http.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/services/api_client.dart';

class AnimalService {
  static Future<List<AnimalModel>> getAnimals() async {
    Response response = await ApiClient().get(Uri.parse('${ApiClient.host}/api/shelter/1002/animal/all'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).map((dynamic data) => AnimalModel.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed fetching animals');
    }
  }

  static void processSwipe(int animalId) async {
    // ignore: avoid_print
    print('Animal $animalId liked');
    await ApiClient().post(
      Uri.parse('${ApiClient.host}/api/interaction/like'),
      body: jsonEncode(<String, List<int>>{
        'ids': <int>[animalId]
      }),
    );
  }

  static Future<List<AnimalModel>> getLikedAnimals() async {
    Response response = await ApiClient().get(Uri.parse('${ApiClient.host}/api/interaction/like?detailed=true'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).map((dynamic data) => AnimalModel.fromJson(data['animal'] as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed fetching animals');
    }
  }
}
