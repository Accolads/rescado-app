import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rescado/src/models/animal_model.dart';

class AnimalService {
  static Future<List<AnimalModel>> getAnimals() async {
    //TODO httpWrapper
    Response response = await http.get(Uri.parse('http://localhost:8282/api/animal'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).map((dynamic data) => AnimalModel.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed fetching blood data');
    }
  }

  //TODO here ?
  static void processSwipe(int animalId, bool like) {
    // ignore: avoid_print
    print('Animal $animalId liked is $like');
  }
}
