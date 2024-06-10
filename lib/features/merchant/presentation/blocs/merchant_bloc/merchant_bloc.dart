import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ksfood/features/merchant/data/models/merchant.dart';
import 'package:ksfood/features/merchant/data/repositories/merchant_repository_impl.dart';

part 'merchant_event.dart';
part 'merchant_state.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  late final StreamSubscription allMerchantStreamSubscription;
  final MerchantRepository merchantRepository;
  MerchantBloc({
    required this.merchantRepository,
  }) : super(MerchantState.initial()) {
    on<MerchantEvent>((event, emit) {});
  }
}
