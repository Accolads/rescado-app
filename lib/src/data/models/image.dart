enum ImageType {
  avatar,
  logo,
  banner,
  photo,
}

enum ImageSource {
  external,
  internal,
}

class Image {
  final int? id;
  final String reference;
  final ImageType type;
  final ImageSource source;

  Image._({
    this.id,
    required this.reference,
    required this.type,
    required this.source,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image._(
        id: json['id'] as int,
        reference: json['reference'] as String,
        type: ImageType.values.byName((json['type'] as String).toLowerCase()),
        source: ImageSource.values.byName((json['source'] as String).toLowerCase()),
      );
}
