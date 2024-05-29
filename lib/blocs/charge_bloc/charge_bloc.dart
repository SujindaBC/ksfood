import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/models/payment_model.dart';
import 'package:http/http.dart' as http;

part 'charge_event.dart';
part 'charge_state.dart';

class ChargeBloc extends Bloc<ChargeEvent, ChargeState> {
  final CartBloc cartBloc;
  final PaymentBloc paymentBloc;
  ChargeBloc({
    required this.cartBloc,
    required this.paymentBloc,
  }) : super(ChargeState.iniitial()) {
    on<CreateCharge>((event, emit) async {
      switch (event.paymentMethod) {
        case PaymentMethod.promptPay:
          try {
            final String? opnSecretKey = dotenv.env["OPN_SECRET_KEY"];
            final Uri url = Uri.parse("https://api.omise.co/charges");
            final String? secreatKey = opnSecretKey;
            final String amount = (cartBloc.state.totalPrice +
                    cartBloc.state
                        .paymentFee(paymentBloc.state.selectedPaymentMethod!))
                .toStringAsFixed(2);
            log(amount.toString(), time: DateTime.now());

            final DateTime currentUtcTime =
                DateTime.now().isUtc ? DateTime.now() : DateTime.now().toUtc();

            log(DateTime.now().toIso8601String());
            log(DateTime.now().toUtc().toIso8601String());

            final expirationTime =
                currentUtcTime.add(const Duration(minutes: 3));

            final formattedExpirationTime = expirationTime.toIso8601String();
            log(formattedExpirationTime);

            final response = await http.post(
              url,
              headers: {
                "Authorization":
                    "Basic ${base64.encode(utf8.encode(secreatKey!))}",
                "Content-Type": "application/x-www-form-urlencoded",
              },
              body: {
                'amount': "${double.parse(amount) * 100}",
                'currency': 'THB',
                "source[type]": paymentMethodString(event.paymentMethod),
                "expires_at": formattedExpirationTime,
              },
            );

            if (response.statusCode == 200) {
              emit(
                state.copyWith(
                  status: ChargeStatus.pending,
                ),
              );
            } else {
              throw Exception(http.BaseResponse);
            }
          } catch (error) {
            emit(state.copyWith(status: ChargeStatus.failed));
            log(error.toString(), error: error);
          }
        // case PaymentMethod.mobileBankingKBank:
          break;
      }
    });
  }
  String paymentMethodString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.promptPay:
        return "promptpay";
      // case PaymentMethod.mobileBankingKBank:
      //   return "mobile_banking_kbank";
    }
  }
}
