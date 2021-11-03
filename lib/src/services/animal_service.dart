import 'dart:convert';

import 'package:http/http.dart';
import 'package:rescado/src/models/animal_model.dart';
import 'package:rescado/src/services/api_client.dart';

class AnimalService {
  static Future<List<AnimalModel>> getAnimals() async {
    Response response = await ApiClient().post(Uri.parse('${ApiClient.host}/api/cards/generate'),
        body: jsonEncode(<String, dynamic>{
          'number': 20,
        }));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).map((dynamic data) => AnimalModel.fromJson(data as Map<String, dynamic>, DateTime.now())).toList();
    } else {
      throw Exception('Failed fetching animals ${response.body}');
    }
  }
}
