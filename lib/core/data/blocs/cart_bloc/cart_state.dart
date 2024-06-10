// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'cart_bloc.dart';

class CartState extends Equatable {
  const CartState({
    required this.status,
    this.merchant,
    this.carts,
    this.selectedCart,
  });

  final CartStateStatus status;
  final Merchant? merchant;
  final List<Cart>? carts;
  final Cart? selectedCart;

  factory CartState.initial() {
    return const CartState(
      status: CartStateStatus.initial,
      carts: [],
    );
  }

  @override
  List<Object?> get props => [status, merchant, carts, selectedCart];

  double get subtotalPrice {
    if (selectedCart == null) {
      return 0.0;
    }

    double subtotal = 0.0;

    for (final item in selectedCart!.items) {
      subtotal += item.product.price * item.quantity;
    }
    return subtotal;
  }

  double get totalPrice {
    double subtotal = subtotalPrice;
    double deliveryFee = 20.0; // Assuming a fixed delivery fee of ฿20.00
    return subtotal + deliveryFee;
  }

  double get vat {
    double subtotal = subtotalPrice;
    double vatAmount = subtotal * 0.07;
    double vatRounded = (vatAmount / 0.25).ceil() * 0.25;
    return vatRounded; // Assuming 7% VAT subtotal
  }

  double get deliveryFee {
    return 20.0; // Assuming a fixed delivery fee of 50.0
  }

  double paymentFee(PaymentMethod paymentMethod) {
    double fee = 0.0;
    switch (paymentMethod) {
      case PaymentMethod.promptPay:
        fee = totalPrice * 0.0165;
        fee = (fee / 0.25).ceil() * 0.25; // Round fee to the nearest 0.50
        break;
      // case PaymentMethod.mobileBankingKBank:
      //   fee = 10.0;
      //   break;
      // Add more cases for other payment methods if needed
      default:
        fee = 0.0;
    }
    if (fee % 0.5 != 0.0) {
      fee = ((fee / 0.5).ceil() * 0.5).toDouble();
    }
    return fee;
  }

  CartState copyWith({
    CartStateStatus? status,
    Merchant? merchant,
    List<Cart>? carts,
    Cart? selectedCart,
  }) {
    return CartState(
      status: status ?? this.status,
      merchant: merchant ?? this.merchant,
      carts: carts ?? this.carts,
      selectedCart: selectedCart ?? this.selectedCart,
    );
  }
}

enum CartStateStatus {
  initial,
  loading,
  loaded,
  error,
}
