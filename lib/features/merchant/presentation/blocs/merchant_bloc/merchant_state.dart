part of 'merchant_bloc.dart';

class MerchantState extends Equatable {
  const MerchantState({
    required this.status,
    this.allMerchants,
    this.nearbyMerchants,
  });

  final MerchantStateStatus status;
  final Iterable<Merchant>? allMerchants;
  final Iterable<Merchant>? nearbyMerchants;

  factory MerchantState.initial() {
    return const MerchantState(
      status: MerchantStateStatus.initial,
      allMerchants: null,
      nearbyMerchants: null
    );
  }

  @override
  List<Object?> get props => [status, allMerchants, nearbyMerchants];
}

enum MerchantStateStatus {
  initial,
  loading,
  loaded,
  error,
}
