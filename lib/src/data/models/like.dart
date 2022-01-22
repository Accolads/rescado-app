import 'package:rescado/src/data/models/animal.dart';

class Like {
  final DateTime timestamp;
  final String? reference;
  final Animal animal;

  Like._({
    required this.timestamp,
    this.reference,
    required this.animal,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like._(
        timestamp: DateTime.parse(json['timestamp'] as String),
        reference: json['reference'] as String?,
        animal: Animal.fromJson(json['animal'] as Map<String, dynamic>),
      );
}
