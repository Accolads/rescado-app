import 'package:rescado/src/data/models/animal.dart';

class Like {
  final Animal animal;
  final DateTime timestamp;
  final String? reference;

  Like._({
    required this.animal,
    required this.timestamp,
    this.reference,
  });

  factory Like.fromAnimal(Animal animal) => Like._(
        animal: animal,
        timestamp: DateTime.now(),
      );

  factory Like.fromJson(Map<String, dynamic> json) => Like._(
        animal: Animal.fromJson(json['animal'] as Map<String, dynamic>),
        timestamp: DateTime.parse(json['timestamp'] as String),
        reference: json['reference'] as String?,
      );
}
