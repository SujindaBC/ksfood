part of 'charge_bloc.dart';

class ChargeState extends Equatable {
  const ChargeState({
    required this.status,
  });

  final ChargeStatus status;

  @override
  List<Object> get props => [status];

  factory ChargeState.iniitial() {
    return const ChargeState(
      status: ChargeStatus.initial,
    );
  }
}

enum ChargeStatus {
  initial,
  pending,
  successful,
  failed,
  expired,
}
