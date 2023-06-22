// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_bloc.dart';

class CartState extends Equatable {
  const CartState({
    required this.status,
    this.merchant,
    this.carts,
  });

  final CartStateStatus status;
  final Merchant? merchant;
  final List<Cart>? carts;

  factory CartState.initial() {
    return const CartState(
      status: CartStateStatus.initial,
      carts: [],
    );
  }

  @override
  List<Object?> get props => [status, merchant, carts];

  CartState copyWith({
    CartStateStatus? status,
    Merchant? merchant,
    List<Cart>? carts,
  }) {
    return CartState(
      status: status ?? this.status,
      merchant: merchant ?? this.merchant,
      carts: carts ?? this.carts,
    );
  }
}

enum CartStateStatus {
  initial,
  loading,
  loaded,
  error,
}
