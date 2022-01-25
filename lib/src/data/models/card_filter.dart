import 'package:rescado/src/data/models/animal.dart';

class CardFilter {
  final int number;
  final List<AnimalKind>? kinds;
  final List<AnimalSex>? sexes;
  final int? minimumAge;
  final int? maximumAge;
  final int? minimumWeight;
  final int? maximumWeight;
  final bool? vaccinated;
  final bool? sterilized;

  CardFilter({
    this.number = 10, // By default, fetch cards in batches of 10
    this.kinds,
    this.sexes,
    this.minimumAge,
    this.maximumAge,
    this.minimumWeight,
    this.maximumWeight,
    this.vaccinated,
    this.sterilized,
  });

  CardFilter copyWith({
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
      CardFilter(
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

  String toJson() => '''{
  "number": $number,
  "kinds": ${kinds?.map((kind) => kind.name)},
  "sexes":  ${sexes?.map((sex) => sex.name)},
  "minimumAge": $minimumAge,
  "maximumAge": $maximumAge,
  "minimumWeight": $minimumWeight,
  "maximumWeight": $maximumWeight,
  "vaccinated": ${vaccinated == true ? true : 'null'},
  "sterilized": ${sterilized == true ? true : 'null'}
  }''';
}
