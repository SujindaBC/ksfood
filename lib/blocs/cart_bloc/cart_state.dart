part of 'cart_bloc.dart';

class CartState extends Equatable {
  const CartState({
    required this.status,
    this.merchantId,
    this.items,
  });

  final CartStateStatus status;
  final String? merchantId;
  final Iterable<CartItem>? items;

  factory CartState.initial() {
    return const CartState(
      status: CartStateStatus.initial,
      items: [],
    );
  }

  @override
  List<Object?> get props => [status, merchantId, items];

  CartState copyWith({
    CartStateStatus? status,
    String? merchantId,
    Iterable<CartItem>? items,
  }) {
    return CartState(
      status: status ?? this.status,
      merchantId: merchantId ?? this.merchantId,
      items: items ?? this.items,
    );
  }
}

enum CartStateStatus {
  initial,
  loading,
  loaded,
  error,
}
