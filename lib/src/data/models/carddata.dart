import 'package:rescado/src/data/models/animal.dart';

class CardData {
  final List<Animal> cards; // cards loaded to display in the stack (cards[0] is the top card)
  final int number; // number of cards to fetch per request -- default value set in constructor
  final List<AnimalKind>? kinds; // filters...
  final List<AnimalSex>? sexes;
  final int? minimumAge;
  final int? maximumAge;
  final int? minimumWeight;
  final int? maximumWeight;
  final bool? vaccinated;
  final bool? sterilized;

  CardData({
    this.cards = const [],
    this.number = 5,
    this.kinds,
    this.sexes,
    this.minimumAge,
    this.maximumAge,
    this.minimumWeight,
    this.maximumWeight,
    this.vaccinated,
    this.sterilized,
  });

  CardData copyWith({
    List<Animal>? cards,
    int? number,
    List<AnimalKind>? kinds,
    List<AnimalSex>? sexes,
    int? minimumAge,
    int? maximumAge,
    int? minimumWeight,
    int? maximumWeight,
    bool? vaccinated,
    bool? sterilized,
  }) =>
      CardData(
        cards: cards ?? this.cards,
        number: number ?? this.number,
        kinds: kinds ?? this.kinds,
        sexes: sexes ?? this.sexes,
        minimumAge: minimumAge ?? this.minimumAge,
        maximumAge: maximumAge ?? this.maximumAge,
        minimumWeight: minimumWeight ?? this.minimumWeight,
        maximumWeight: maximumWeight ?? this.maximumWeight,
        vaccinated: vaccinated ?? this.vaccinated,
        sterilized: sterilized ?? this.sterilized,
      );
}
