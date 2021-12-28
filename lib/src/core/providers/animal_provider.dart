import 'package:flutter/material.dart';

class AnimalProvider with ChangeNotifier {
  bool likedCurrentAnimal = false;

  void resetLikedCurrentAnimal() => likedCurrentAnimal = false;

  void updateLikedCurrentAnimal() {
    likedCurrentAnimal = !likedCurrentAnimal;
    notifyListeners();
  }
}
