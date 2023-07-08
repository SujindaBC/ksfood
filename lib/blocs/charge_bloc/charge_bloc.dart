import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/models/charge.dart';
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
            final Uri url = Uri.parse("https://api.omise.co/charges");
            const String secreatKey = "skey_test_5nxdvpc87vwsrpu6zgo";
            final String amount = (cartBloc.state.totalPrice +
                    cartBloc.state
                        .paymentFee(paymentBloc.state.selectedPaymentMethod!))
                .toStringAsFixed(2);
            log(amount.toString());
            final response = await http.post(
              url,
              headers: {
                "Authorization":
                    "Basic ${base64.encode(utf8.encode(secreatKey))}",
                "Content-Type": "application/x-www-form-urlencoded",
              },
              body: {
                'amount': "${double.parse(amount) * 100}",
                'currency': 'THB',
                "source[type]": paymentMethodString(event.paymentMethod),
                "expires_at": DateTime.now()
                    .add(
                      const Duration(
                        seconds: 179,
                      ),
                    )
                    .toString(),
              },
            );
            if (response.statusCode == 200) {
              final Map<String, dynamic> responseData =
                  json.decode(response.body);
              final Charge charge = Charge.fromMap(responseData);
              emit(
                state.copyWith(
                  status: ChargeStatus.pending,
                  change: charge,
                ),
              );
            } else {
              throw Exception(http.BaseResponse);
            }
          } catch (error) {
            log(error.toString(), error: error);
          }
        case PaymentMethod.mobileBankingKBank:
          break;
      }
    });
  }
  String paymentMethodString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.promptPay:
        return "promptpay";
      case PaymentMethod.mobileBankingKBank:
        return "mobile_banking_kbank";
    }
  }
}
