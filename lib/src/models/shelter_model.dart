import 'package:rescado/src/models/coordinates_model.dart';
import 'package:rescado/src/models/image_model.dart';

class ShelterModel {
  int id;
  String name;
  String city;
  String country;
  CoordinatesModel coordinates;
  ImageModel logo;

  ShelterModel({required this.id, required this.name, required this.city, required this.country, required this.coordinates, required this.logo});

  factory ShelterModel.fromJson(Map<String, dynamic> json) => ShelterModel(
        id: json['id'] as int,
        name: json['name'] as String,
        city: json['city'] as String,
        country: json['country'] as String,
        coordinates: CoordinatesModel.fromJson(json['coordinates'] as Map<String, dynamic>),
        logo: ImageModel.fromJson(json['logo'] as Map<String, dynamic>),
      );
}
