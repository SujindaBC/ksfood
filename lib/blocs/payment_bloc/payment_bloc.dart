import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:ksfood/models/payment_model.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentState.initial()) {
    on<SelectPaymentMethod>((event, emit) {
      emit(state.copyWith(selectedPaymentMethod: event.paymentMethod));
    });

    on<ProcessPayment>((event, emit) async {
      try {
        final paymentSource = await createPaymentSource();
        final charge = await createCharge(paymentSource['id']);
        final chargeStatus = await checkChargeStatus(charge['id']);

        // Perform the payment processing logic here
        switch (chargeStatus) {
          case "pending":
            emit(
              state.copyWith(
                status: PaymentStatus.pending,
              ),
            );
            break;
          case "successful":
            // If payment is successful
            emit(
              state.copyWith(
                status: PaymentStatus.successful,
              ),
            );
            break;
          case "failed":
            // If payment fails
            emit(
              state.copyWith(
                status: PaymentStatus.failed,
              ),
            );
            break;
          case "expired":
            // If expired
            emit(
              state.copyWith(
                status: PaymentStatus.expired,
              ),
            );
            break;
        }
      } catch (error) {
        emit(
          state.copyWith(
            status: PaymentStatus.failed,
          ),
        );
      }
    });
  }

  Future<Map<String, dynamic>> createPaymentSource() async {
    final response = await http.post(
      Uri.parse('https://api.omise.co/sources'),
      headers: {'Authorization': 'Bearer YOUR_API_KEY'},
      body: {
        'amount': '400000',
        'currency': 'THB',
        'type': 'promptpay',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create payment source');
    }
  }

  Future<Map<String, dynamic>> createCharge(String sourceId) async {
    final response = await http.post(
      Uri.parse('https://api.omise.co/sources'),
      headers: {'Authorization': 'Bearer YOUR_API_KEY'},
      body: {'source': sourceId},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create charge');
    }
  }

  Future<String> checkChargeStatus(String chargeId) async {
    final response = await http.get(
      Uri.parse('https://api.omise.co/sources'),
      headers: {'Authorization': 'Bearer YOUR_API_KEY'},
    );

    if (response.statusCode == 200) {
      final charge = jsonDecode(response.body);
      return charge['status'];
    } else {
      throw Exception('Failed to retrieve charge status');
    }
  }
}
