import 'dart:convert';

class Merchant {
  Merchant({
    required this.id,
    required this.name,
    this.description,
    required this.image,
    required this.rating,
  });

  final String id;
  final String name;
  final String? description;
  final String image;
  final num rating;

  Merchant copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    num? rating,
  }) {
    return Merchant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'rating': rating,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Merchant.fromJson(String source) =>
      Merchant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Merchant(id: $id, name: $name, description: $description, image: $image, rating: $rating)';
  }
}
