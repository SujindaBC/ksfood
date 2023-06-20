import 'dart:convert';

import 'package:ksfood/models/product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    required this.comment,
  });
  final Product product;
  final int quantity;
  final String comment;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? comment,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.toMap(),
      'quantity': quantity,
      'comment': comment,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      comment: map['comment'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartItem(product: ${product.name}, quantity: $quantity, comment: $comment)';
}
