import 'package:rescado/src/data/models/animal.dart';

class LikeAction {
  final List<Animal> likes;
  final List<String> errors;

  LikeAction._({
    required this.likes,
    required this.errors,
  });

  factory LikeAction.fromJsonWithAnimalData(Map<String, dynamic> json, List<Animal> animals) {
    return LikeAction._(
      likes: (json['likes'] as List<int>).map((id) => animals.firstWhere((animal) => animal.id == id)).toList(),
      errors: json['errors'] as List<String>,
    );
  }
}
