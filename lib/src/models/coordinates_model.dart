class CoordinatesModel {
  double latitude;
  double longitude;

  CoordinatesModel({required this.latitude, required this.longitude});

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      latitude: json['latitude'] as double,
      longitude: json['latitude'] as double,
    );
  }
}
