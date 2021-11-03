import 'package:rescado/src/models/image_model.dart';
import 'package:rescado/src/models/shelter_model.dart';

class AnimalModel {
  int id;
  String kind;
  String breed;
  String name;
  String description;
  String sex;
  int age;
  int weight;
  bool vaccinated;
  bool sterilized;
  List<ImageModel> photos;
  ShelterModel shelter;

  AnimalModel({required this.id, required this.kind, required this.breed, required this.name, required this.description, required this.sex, required this.age, required this.weight, required this.vaccinated, required this.sterilized, required this.photos, required this.shelter});

  factory AnimalModel.fromJson(Map<String, dynamic> json, DateTime now) => AnimalModel(
        id: json['id'] as int,
        kind: json['kind'] as String,
        breed: json['breed'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        sex: json['sex'] as String,
        age: calculateAge(now, DateTime.parse(json['birthday'] as String)),
        weight: json['weight'] as int,
        vaccinated: json['vaccinated'] as bool,
        sterilized: json['sterilized'] as bool,
        photos: (json['photos'] as List<dynamic>).map((dynamic e) => ImageModel.fromJson(e as Map<String, dynamic>)).toList(),
        shelter: ShelterModel.fromJson(json['shelter'] as Map<String, dynamic>),
      );

  // TODO move to utils file
  static int calculateAge(DateTime now, DateTime birthday) => (now.difference(birthday).inHours / 24 / 365).floor();
}
