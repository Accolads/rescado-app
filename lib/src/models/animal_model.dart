import 'package:rescado/src/models/shelter_model.dart';

class AnimalModel {
  int id;
  String kind;
  String breed;
  String name;
  String description =
      'Werken wil Loebas wel en spelen is ook zeker een hobby. Je hebt zijn volledige aandacht wanneer je lekkere vleesjes hebt en dan merk je ook dat hij de basiscommando’s van thuis uit kent. Hij kent de commando’s ‘zit, ‘liggen’, ‘poot’ en ‘blijf’ en gezien zijn leergierigheid, weten we zeker dat hij véél meer commando’s kan lerenWerken wil Loebas wel en spelen is ook zeker een hobby. Je hebt zijn volledige aandacht wanneer je lekkere vleesjes hebt en dan merk je ook dat hij de basiscommando’s van thuis uit kent. Hij kent de commando’s ‘zit, ‘liggen’, ‘poot’ en ‘blijf’ en gezien zijn leergierigheid, weten we zeker dat hij véél meer commando’s kan leren.';
  String sex;
  int age;
  int weight;
  bool vaccinated;
  bool castrated;
  List<String> photos;
  ShelterModel shelter;

  AnimalModel({required this.id, required this.kind, required this.breed, required this.name, required this.sex, required this.age, required this.weight, required this.vaccinated, required this.castrated, required this.photos, required this.shelter});

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      id: json['id'] as int,
      kind: json['kind'] as String,
      breed: json['breed'] as String,
      name: json['name'] as String,
      sex: json['sex'] as String,
      age: json['age'] as int,
      weight: json['weight'] as int,
      vaccinated: json['vaccinated'] as bool,
      castrated: json['sterilized'] as bool,
      photos: json['photos'].cast<String>() as List<String>,
      shelter: ShelterModel.fromJson(json['shelter'] as Map<String, dynamic>),
    );
  }
}
