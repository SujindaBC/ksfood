part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class SelectPaymentMethod extends PaymentEvent {
  final PaymentMethod paymentMethod;

  const SelectPaymentMethod({required this.paymentMethod});

  @override
  List<Object> get props => [paymentMethod];
}

class ClearSelectedPayment extends PaymentEvent {
  const ClearSelectedPayment();
}

class ProcessPayment extends PaymentEvent {
  const ProcessPayment();
}
