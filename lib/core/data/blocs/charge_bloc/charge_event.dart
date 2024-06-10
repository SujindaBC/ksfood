part of 'charge_bloc.dart';

abstract class ChargeEvent extends Equatable {
  const ChargeEvent();

  @override
  List<Object> get props => [];
}

class CreateCharge extends ChargeEvent {
  final BuildContext context;
  final PaymentMethod paymentMethod;
  final Merchant merchant;

  const CreateCharge({
    required this.context,
    required this.paymentMethod,
    required this.merchant,
  });

  @override
  List<Object> get props => [context, paymentMethod, merchant];
}
