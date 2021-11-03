class ImageModel {
  final int? id;
  final String reference;
  final String type;
  final String source;

  ImageModel({this.id, required this.reference, required this.type, required this.source});

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json['id'] as int?,
        reference: json['reference'] as String,
        type: json['type'] as String,
        source: json['source'] as String,
      );
}
