import 'dart:convert';

import 'package:ksfood/models/product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    required this.note,
  });
  final Product product;
  final int quantity;
  final String note;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? note,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.toMap(),
      'quantity': quantity,
      'note': note,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      note: map['note'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CartItem(product: $product, quantity: $quantity, note: $note)';

  @override
  bool operator ==(covariant CartItem other) {
    if (identical(this, other)) return true;

    return other.product == product &&
        other.quantity == quantity &&
        other.note == note;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode ^ note.hashCode;
}
