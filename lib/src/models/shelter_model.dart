import 'package:rescado/src/models/coordinates_model.dart';

class ShelterModel {
  int id;
  String name;
  String city;
  String country;
  CoordinatesModel coordinates;
  String logo;

  ShelterModel({required this.id, required this.name, required this.city, required this.country, required this.coordinates, required this.logo});

  factory ShelterModel.fromJson(Map<String, dynamic> json) {
    return ShelterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      coordinates: CoordinatesModel.fromJson(json['coordinates'] as Map<String, dynamic>),
      logo: json['logo']['reference'] as String,
    );
  }
}
