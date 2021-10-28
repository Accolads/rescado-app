import 'dart:convert';

import 'package:http/http.dart';
import 'package:rescado/src/models/shelter_model.dart';
import 'package:rescado/src/services/api_client.dart';

const String shelterExample = '{"id": 1004,"name": "Dierenasiel Genk","email": "rescado.shelter320@qrivi.dev","website": "https://shelter170.rescado.qrivi.dev","address": "Europalaan 13","postalCode": "3600","city": "Genk","country": "BE","coordinates": {"latitude": 8.3297,"longitude": -63.9405},"logo": {"reference": "https://www.one2give.nl/uploads/wish-146/1200x630-wensafbeelding.jpg","type": "LOGO","source": "EXTERNAL"}}';
const String shelter2Example = '{"id": 1005,"name": "Animal Care España","email": "rescado.shelter320@qrivi.dev","website": "https://shelter170.rescado.qrivi.dev","address": "Calle Patrice Lumumba 59","postalCode": "9999","city": "La Cala de Mijas","country": "ES","coordinates": {"latitude": 8.3297,"longitude": -63.9405},"logo": {"reference": "https://ace-charity.org/wp-content/uploads/2021/04/renderlofthelpus.png","type": "LOGO","source": "EXTERNAL"}}';

class ShelterService {
  static Future<List<ShelterModel>> getShelters() async {
    Response response = await ApiClient().get(Uri.parse('${ApiClient.host}/api/shelter/all'));

    List<ShelterModel> shelters = []; //TODO remove
    shelters.add(ShelterModel.fromJson(jsonDecode(shelterExample) as Map<String, dynamic>));
    shelters.add(ShelterModel.fromJson(jsonDecode(shelter2Example) as Map<String, dynamic>));
    shelters.add(ShelterModel.fromJson(jsonDecode(shelterExample) as Map<String, dynamic>));
    shelters.add(ShelterModel.fromJson(jsonDecode(shelter2Example) as Map<String, dynamic>));
    return shelters;

    // ignore: dead_code
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>).map((dynamic data) => ShelterModel.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed fetching shelters');
    }
  }
}
