// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Merchant {
  Merchant({
    required this.id,
    required this.name,
    this.description,
    required this.image,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.isAvailable,
  });

  final String id;
  final String name;
  final String? description;
  final String image;
  final num rating;
  final num latitude;
  final num longitude;
  final bool isAvailable;

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'name': name,
  //     'description': description,
  //     'image': image,
  //     'rating': rating,
  //     'latitude': latitude,
  //     'longitude': longitude,
  //   };
  // }

  // factory Merchant.fromMap(Map<String, dynamic> map) {
  //   return Merchant(
  //     id: map['id'] as String,
  //     name: map['name'] as String,
  //     description:
  //         map['description'] != null ? map['description'] as String : null,
  //     image: map['image'] as String,
  //     rating: map['rating'] as num,
  //     latitude: map['latitude'] as num,
  //     longitude: map['longitude'] as num,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory Merchant.fromJson(String source) =>
  //     Merchant.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // String toString() {
  //   return 'Merchant(id: $id, name: $name, description: $description, image: $image, rating: $rating, latitude: $latitude, longitude: $longitude)';
  // }

  Merchant copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    num? rating,
    num? latitude,
    num? longitude,
    bool? isAvailable,
  }) {
    return Merchant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
      'isAvailable': isAvailable,
    };
  }

  factory Merchant.fromMap(Map<String, dynamic> map) {
    return Merchant(
      id: map['id'] as String,
      name: map['name'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      image: map['image'] as String,
      rating: map['rating'] as num,
      latitude: map['latitude'] as num,
      longitude: map['longitude'] as num,
      isAvailable: map['isAvailable'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Merchant.fromJson(String source) =>
      Merchant.fromMap(json.decode(source) as Map<String, dynamic>);
}
