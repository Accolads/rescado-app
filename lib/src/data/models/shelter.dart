import 'package:rescado/src/data/models/coordinates.dart';
import 'package:rescado/src/data/models/image.dart';

class Shelter {
  final int id;
  final String name;
  final String? email;
  final String? website;
  final String? newsfeed;
  final String? address;
  final String? postalCode;
  final String city;
  final String country;
  final Coordinates coordinates;
  final Image logo;
  final Image? banner;

  Shelter._({
    required this.id,
    required this.name,
    this.email,
    this.website,
    this.newsfeed,
    this.address,
    this.postalCode,
    required this.city,
    required this.country,
    required this.coordinates,
    required this.logo,
    this.banner,
  });

  factory Shelter.fromJson(Map<String, dynamic> json) => Shelter._(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String?,
        website: json['website'] as String?,
        newsfeed: json['newsfeed'] as String?,
        address: json['address'] as String?,
        postalCode: json['postalCode'] as String?,
        city: json['city'] as String,
        country: json['country'] as String,
        coordinates: Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
        logo: Image.fromJson(json['logo'] as Map<String, dynamic>),
        banner: json['banner'] == null ? null : Image.fromJson(json['banner'] as Map<String, dynamic>),
      );
}
