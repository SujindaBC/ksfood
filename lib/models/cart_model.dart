// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ksfood/models/cart_item.dart';
import 'package:ksfood/models/merchant.dart';

class Cart {
  Cart({
    required this.id,
    required this.items,
    required this.merchant,
    required this.timeCreated,
  });

  final String id;
  final List<CartItem> items;
  final Merchant merchant;
  final DateTime timeCreated;

  double get totalPrice {
    double total = 0.0;
    for (final item in items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  Cart copyWith({
    String? id,
    List<CartItem>? items,
    Merchant? merchant,
    DateTime? timeCreated,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      merchant: merchant ?? this.merchant,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'items': items.map((x) => x.toMap()).toList(),
      'merchant': merchant.toMap(),
      'timeCreated': timeCreated.millisecondsSinceEpoch,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] as String,
      items: (map['items'] as List<dynamic>)
          .map<CartItem>(
            (item) => CartItem.fromMap(item as Map<String, dynamic>),
          )
          .toList(),
      merchant: Merchant.fromMap(map['merchant'] as Map<String, dynamic>),
      timeCreated:
          DateTime.fromMillisecondsSinceEpoch(map['timeCreated'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cart(id: $id, items: $items, merchant: $merchant, timeCreated: $timeCreated)';
  }

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.items, items) &&
        other.merchant == merchant &&
        other.timeCreated == timeCreated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        items.hashCode ^
        merchant.hashCode ^
        timeCreated.hashCode;
  }
}
