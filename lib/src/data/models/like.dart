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
        timestamp: json['timestamp'] as DateTime,
        reference: json['reference'] as String?,
        animal: Animal.fromJson(json['reference'] as Map<String, dynamic>),
      );
}
