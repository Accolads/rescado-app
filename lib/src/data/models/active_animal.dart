import 'package:rescado/src/data/models/animal.dart';

class ActiveAnimal {
  final Animal animal;
  final bool isLiked;

  ActiveAnimal({
    required this.animal,
    this.isLiked = false,
  });
}
