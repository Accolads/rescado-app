enum ApiImageType {
  avatar,
  logo,
  banner,
  photo,
}

enum ApiImageSource {
  external,
  internal,
}

class ApiImage {
  final int? id;
  final String reference;
  final ApiImageType type;
  final ApiImageSource source;

  ApiImage._({
    this.id,
    required this.reference,
    required this.type,
    required this.source,
  });

  factory ApiImage.fromJson(Map<String, dynamic> json) => ApiImage._(
        id: json['id'] as int,
        reference: json['reference'] as String,
        type: ApiImageType.values.byName((json['type'] as String).toLowerCase()),
        source: ApiImageSource.values.byName((json['source'] as String).toLowerCase()),
      );
}
