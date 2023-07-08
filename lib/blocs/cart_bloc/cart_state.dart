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

  double get subtotalPrice {
    if (carts == null || carts!.isEmpty) {
      return 0.0;
    }

    double subtotal = 0.0;
    for (final cart in carts!) {
      subtotal += cart.totalPrice;
    }
    return subtotal;
  }

  double get totalPrice {
    double subtotal = subtotalPrice;
    double deliveryFee = 20.0; // Assuming a fixed delivery fee of ฿20.00
    return subtotal + deliveryFee + vat;
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
      case PaymentMethod.mobileBankingKBank:
        fee = 10.0;
        break;
      // Add more cases for other payment methods if needed
      default:
        fee = 0.0;
    }
    if (fee % 0.5 != 0.0) {
      fee = ((fee / 0.5).ceil() * 0.5).toDouble();
    }
    return fee;
  }
}

enum CartStateStatus {
  initial,
  loading,
  loaded,
  error,
}
