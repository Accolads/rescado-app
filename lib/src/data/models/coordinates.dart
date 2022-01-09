class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates._({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates._(
        latitude: json['latitude'] as double,
        longitude: json['longitude'] as double,
      );
}
