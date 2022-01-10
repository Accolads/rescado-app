import 'package:rescado/src/data/models/image.dart';
import 'package:rescado/src/data/models/shelter.dart';

class Animal {
  final int id;
  final String name;
  final String? description;
  final String kind;
  final String breed;
  final String sex;
  final DateTime? birthday;
  final int? weight;
  final bool? vaccinated;
  final bool? sterilized;
  final String availability;
  final List<Image> photos;
  final Shelter shelter;

  Animal._({
    required this.id,
    required this.name,
    this.description,
    required this.kind,
    required this.breed,
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
        name: json['name'] as String,
        description: json['description'] as String?,
        kind: json['kind'] as String,
        breed: json['breed'] as String,
        sex: json['sex'] as String,
        birthday: json['birthday'] as DateTime?,
        weight: json['weight'] as int?,
        vaccinated: json['vaccinated'] as bool?,
        sterilized: json['sterilized'] as bool?,
        availability: json['availability'] as String,
        photos: (json['photos'] as List<Map<String, dynamic>>).map((photo) => Image.fromJson(photo)).toList(),
        shelter: Shelter.fromJson(json['shelter'] as Map<String, dynamic>),
      );
}
