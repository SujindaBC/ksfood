// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isAvailable,
    required this.merchantId,
    required this.price,
    required this.rating,
    this.category,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isAvailable;
  final String merchantId;
  final num price;
  final num rating;
  final List<dynamic>? category;

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    bool? isAvailable,
    String? merchantId,
    num? price,
    num? rating,
    List<dynamic>? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      merchantId: merchantId ?? this.merchantId,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'merchantId': merchantId,
      'price': price,
      'rating': rating,
      'category': category,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      isAvailable: map['isAvailable'] as bool,
      merchantId: map['merchantId'] as String,
      price: map['price'] as num,
      rating: map['rating'] as num,
      category: map['category'] != null
          ? List<dynamic>.from(map['category'] as List<dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, imageUrl: $imageUrl, isAvailable: $isAvailable, merchantId: $merchantId, price: $price, rating: $rating, category: $category)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.isAvailable == isAvailable &&
        other.merchantId == merchantId &&
        other.price == price &&
        other.rating == rating &&
        listEquals(other.category, category);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        isAvailable.hashCode ^
        merchantId.hashCode ^
        price.hashCode ^
        rating.hashCode ^
        category.hashCode;
  }
}
