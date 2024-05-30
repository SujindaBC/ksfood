import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:ksfood/models/cart_item.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final List<CartItem> cartItems;
  final Location merchantLocation;
  final Location deliveryLocation;
  final double totalPrice;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.cartItems,
    required this.merchantLocation,
    required this.deliveryLocation,
    required this.totalPrice,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map["order_id"],
      userId: map["user_id"],
      cartItems: List<CartItem>.from(
        map["cart_items"].map((item) => CartItem.fromMap(item)),
      ),
      merchantLocation: Location.fromMap(map["merchant_location"]),
      deliveryLocation: Location.fromMap(map["delivery_location"]),
      totalPrice: map["total_price"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "order_id": orderId,
      "user_id": userId,
      "cart_items": cartItems.map((item) => item.toMap()).toList(),
      "merchant_location": merchantLocation.toJson(),
      "delivery_location": deliveryLocation.toJson(),
      "total_price": totalPrice,
    };
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}
