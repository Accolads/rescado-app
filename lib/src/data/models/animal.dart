import 'package:rescado/src/data/models/image.dart';
import 'package:rescado/src/data/models/shelter.dart';

enum AnimalKind {
  dog,
  cat,
}

enum AnimalSex {
  male,
  female,
}

class Animal {
  final int id;
  final AnimalKind kind;
  final String breed;
  final String name;
  final String? description;
  final AnimalSex sex;
  final DateTime? birthday;
  final int? weight;
  final bool? vaccinated;
  final bool? sterilized;
  final String availability;
  final List<Image> photos;
  final Shelter shelter;

  Animal._({
    required this.id,
    required this.kind,
    required this.breed,
    required this.name,
    this.description,
    required this.sex,
    this.birthday,
    this.weight,
    this.vaccinated,
    this.sterilized,
    required this.availability,
    required this.photos,
    required this.shelter,
  });

  factory Animal.fromJson(Map<String, dynamic> json) => Animal._(
        id: json['id'] as int,
        kind: AnimalKind.values.byName((json['kind'] as String).toLowerCase()),
        breed: json['breed'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        sex: AnimalSex.values.byName((json['sex'] as String).toLowerCase()),
        birthday: json['birthday'] as DateTime?,
        weight: json['weight'] as int?,
        vaccinated: json['vaccinated'] as bool?,
        sterilized: json['sterilized'] as bool?,
        availability: json['availability'] as String,
        photos: (json['photos'] as List<Map<String, dynamic>>).map((photo) => Image.fromJson(photo)).toList(),
        shelter: Shelter.fromJson(json['shelter'] as Map<String, dynamic>),
      );
}
