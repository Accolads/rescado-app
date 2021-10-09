class AnimalModel {
  int id;
  String kind;
  String breed;
  String name;
  String sex;
  int age;
  int weight;
  bool vaccinated;
  bool castrated;

  AnimalModel({required this.id, required this.kind, required this.breed, required this.name, required this.sex, required this.age, required this.weight, required this.vaccinated, required this.castrated});
  // factory AnimalModel.fromJson(Map<String, dynamic> json) {
  //   return AnimalModel(
  //     id: json!!!['id'],
  //     email: json!['email'],
  //     name: json['name'],
  //   );
  // }
}
