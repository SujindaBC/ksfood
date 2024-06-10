import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksfood/core/data/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/core/data/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/core/data/models/cart_model.dart';
import 'package:ksfood/features/merchant/data/models/merchant.dart';
import 'package:ksfood/core/data/models/payment_model.dart';
import 'package:http/http.dart' as http;

part 'charge_event.dart';
part 'charge_state.dart';

class ChargeBloc extends Bloc<ChargeEvent, ChargeState> {
  final CartBloc cartBloc;
  final PaymentBloc paymentBloc;

  ChargeBloc({
    required this.cartBloc,
    required this.paymentBloc,
  }) : super(ChargeState.initial()) {
    on<CreateCharge>((event, emit) async {
      emit(state.copyWith(status: ChargeStatus.pending));
      final responseBody = await _createCharge(
        context: event.context,
        paymentMethod: event.paymentMethod,
        merchant: event.merchant,
        selectedCart: cartBloc.state.selectedCart!,
        amount: (cartBloc.state.selectedCart!.totalPrice +
                cartBloc.state
                    .paymentFee(paymentBloc.state.selectedPaymentMethod!))
            .toStringAsFixed(2),
        onChargeCreated: (chargeData) {
          log("Charge created with data: $chargeData");
        },
      );

      if (responseBody != null && responseBody.containsKey("id")) {
        emit(state.copyWith(
          status: ChargeStatus.successful,
          responseBody: responseBody,
        ));
      } else {
        emit(state.copyWith(status: ChargeStatus.failed));
      }
    });
  }

  Future<Map<String, dynamic>?> _createCharge({
    required BuildContext context,
    required PaymentMethod paymentMethod,
    required Merchant merchant,
    required Cart selectedCart,
    required String amount,
    required Function(Map<String, dynamic>) onChargeCreated,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final cartItems = selectedCart.items.map((item) {
      return {
        "id": item.product.id,
        "name": item.product.name,
        "quantity": item.quantity,
        "price": item.product.price,
      };
    }).toList();

    final String orderId =
        FirebaseFirestore.instance.collection("orders").doc().id;

    await FirebaseFirestore.instance.collection("orders").doc(orderId).set({
      "userId": user.uid,
      "merchantId": merchant.id,
      "cartItems": cartItems,
      "totalPrice":
          selectedCart.totalPrice + cartBloc.state.paymentFee(paymentMethod),
      "status": "created",
      "createdAt": FieldValue.serverTimestamp(),
    });

    switch (paymentMethod) {
      case PaymentMethod.promptPay:
        try {
          final Uri url = Uri.parse("https://api.omise.co/charges");
          const String secretKey = "skey_test_5nxdvpc87vwsrpu6zgo";

          final response = await http.post(
            url,
            headers: {
              "Authorization": "Basic ${base64.encode(utf8.encode(secretKey))}",
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: {
              "amount": "${(double.parse(amount) * 100).toInt()}",
              "currency": "THB",
              "source[type]": paymentMethodString(paymentMethod),
              "expires_at": DateTime.now()
                  .toUtc()
                  .add(const Duration(minutes: 3))
                  .toIso8601String(),
              "metadata[order_id]": orderId,
              "metadata[user_id]": user.uid,
            },
          );

          if (response.statusCode == 200) {
            final Map<String, dynamic> chargeData = json.decode(response.body);
            final DocumentReference chargeRef = FirebaseFirestore.instance
                .collection("charges")
                .doc(chargeData["id"]);
            await chargeRef.set(chargeData);

            final DocumentSnapshot chargeSnapshot = await chargeRef.get();
            final charge = chargeSnapshot.data() as Map<String, dynamic>;
            onChargeCreated(charge);
            return charge;
          } else {
            log(response.body);
            return null;
          }
        } on http.BaseResponse catch (error) {
          log(error.toString());
          return null;
        }
      default:
        return null;
    }
  }

  String paymentMethodString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.promptPay:
        return "promptpay";
    }
  }
}
