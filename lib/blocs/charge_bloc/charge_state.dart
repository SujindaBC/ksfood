part of 'charge_bloc.dart';

class ChargeState extends Equatable {
  const ChargeState({
    required this.status,
    this.responseBody,
  });

  final ChargeStatus status;
  final Map<String, dynamic>? responseBody; // Add responseBody here

  @override
  List<Object?> get props => [status, responseBody];

  factory ChargeState.initial() {
    return const ChargeState(
      status: ChargeStatus.initial,
    );
  }

  ChargeState copyWith({
    ChargeStatus? status,
    Map<String, dynamic>? responseBody,
  }) {
    return ChargeState(
      status: status ?? this.status,
      responseBody: responseBody ?? this.responseBody,
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
