import 'package:flutter/material.dart';
import 'package:rescado/src/models/animal_model.dart';

class AnimalController with ChangeNotifier {
  AnimalController();

  late AnimalModel _currentAnimal;

  AnimalModel get currentAnimal => _currentAnimal;

  Future<void> updateCurrentAnimal(AnimalModel animalModel) async {
    _currentAnimal = animalModel;
    notifyListeners();
  }
}
