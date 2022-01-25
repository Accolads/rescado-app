import 'package:rescado/src/data/models/animal.dart';

class CardAction {
  final List<Animal>? liked;
  final List<Animal>? skipped;
  final List<String>? errors;

  CardAction._({
    this.liked,
    this.skipped,
    this.errors,
  });

  // TODO Test/try, because I am 1000% sure this will fail because of casting errors AND lack of null checks
  factory CardAction.fromJsonWithAnimalData(Map<String, dynamic> json, List<Animal> animals) {
    return CardAction._(
      liked: (json['liked'] as List<int>).map((id) => animals.firstWhere((animal) => animal.id == id)).toList(),
      skipped: (json['skipped'] as List<int>).map((id) => animals.firstWhere((animal) => animal.id == id)).toList(),
      errors: json['errors'] as List<String>,
    );
  }
}
