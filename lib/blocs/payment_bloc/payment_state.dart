// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  const PaymentState({
    required this.status,
    this.selectedPaymentMethod,
  });

  final PaymentStatus status;
  final PaymentMethod? selectedPaymentMethod;

  factory PaymentState.initial() {
    return const PaymentState(
      status: PaymentStatus.initial,
    );
  }

  @override
  List<Object?> get props => [status, selectedPaymentMethod];

  

  PaymentState copyWith({
    PaymentStatus? status,
    PaymentMethod? selectedPaymentMethod,
  }) {
    return PaymentState(
      status: status ?? this.status,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }
}

enum PaymentStatus {
  initial,
  pending,
  successful,
  failed,
  expired,
}
