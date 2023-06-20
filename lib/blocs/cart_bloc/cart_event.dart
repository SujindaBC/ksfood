part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddProductToCart extends CartEvent {
  const AddProductToCart({
    required this.merchantId,
    required this.product,
    required this.quantity,
    required this.comment,
  });

  final String merchantId;
  final Product product;
  final int quantity;
  final String comment;

  @override
  List<Object> get props => [merchantId, product, quantity, comment];
}

class RemoveProductFromCart extends CartEvent {
  const RemoveProductFromCart({
    required this.product,
    required this.qauntity,
  });

  final Product product;
  final int qauntity;

  @override
  List<Object> get props => [product, qauntity];
}

class ClearCart extends CartEvent {
  const ClearCart();
}
