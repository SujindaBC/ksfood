part of 'merchant_bloc.dart';

sealed class MerchantEvent extends Equatable {
  const MerchantEvent();

  @override
  List<Object?> get props => [];
}

class GetAllMerchants extends MerchantEvent {
  const GetAllMerchants({
    required this.merchants,
  });

  final Iterable<Merchant>? merchants;

  @override
  List<Object?> get props => [merchants];
}

class GetNearbyMerchants extends MerchantEvent {
  const GetNearbyMerchants({
    required this.merchants,
  });

  final Iterable<Merchant>? merchants;

  @override
  List<Object?> get props => [merchants];
}
