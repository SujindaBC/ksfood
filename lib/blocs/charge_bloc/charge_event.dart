part of 'charge_bloc.dart';

abstract class ChargeEvent extends Equatable {
  const ChargeEvent();

  @override
  List<Object> get props => [];
}

class CreateCharge extends ChargeEvent {
  const CreateCharge({
    required this.amount,
    required this.paymentMethod,
  });

  final String amount;
  final PaymentMethod paymentMethod;

  @override
  List<Object> get props => [];
}
