part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddProductToCart extends CartEvent {
  const AddProductToCart({
    required this.merchant,
    required this.product,
    required this.quantity,
    required this.note,
  });

  final Merchant merchant;
  final Product product;
  final int quantity;
  final String note;

  @override
  List<Object> get props => [merchant, product, quantity, note];
}

class RemoveProductFromCart extends CartEvent {
  const RemoveProductFromCart({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  @override
  List<Object> get props => [product, quantity];
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class SelectCart extends CartEvent {
  const SelectCart({
    required this.selectedCart,
  });

  final Cart selectedCart;

  @override
  List<Object> get props => [selectedCart];
}
