import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/loading/loading_screen.dart';
import 'package:ksfood/models/merchant.dart';
import 'package:ksfood/models/payment_model.dart';
import 'package:http/http.dart' as http;
import 'package:ksfood/screens/promptpay/promptpay_screen.dart';

class ProceedToPaymentButton extends StatelessWidget {
  const ProceedToPaymentButton({
    required this.merchant,
    super.key,
  });

  final Merchant merchant;

  Future<String> _createCharge({
    required BuildContext context,
    required PaymentMethod paymentMethod,
    required Function(Map<String, dynamic>) onChargeCreated,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return "User not logged in";

    final selectedCart = context.read<CartBloc>().state.selectedCart;
    if (selectedCart == null) return "No cart selected";

    final cartItems = selectedCart.items.map((item) {
      return {
        "id": item.product.id,
        "name": item.product.name,
        "quantity": item.quantity,
        "price": item.product.price,
      };
    }).toList();

    // Generate a unique order ID
    final String orderId =
        FirebaseFirestore.instance.collection("orders").doc().id;

    // Store initial order details in Firestore
    await FirebaseFirestore.instance.collection("orders").doc(orderId).set({
      "userId": user.uid,
      "merchantId": merchant.id,
      "cartItems": cartItems,
      "totalPrice": selectedCart.totalPrice,
      "status": "created",
      "createdAt": FieldValue.serverTimestamp(),
    });

    // TODO:: Don't use 'BuildContext's across async gaps.

    switch (paymentMethod) {
      case PaymentMethod.promptPay:
        try {
          final Uri url = Uri.parse("https://api.omise.co/charges");
          const String secreatKey = "skey_test_5nxdvpc87vwsrpu6zgo";
          final String amount = (selectedCart.totalPrice +
                  context.read<CartBloc>().state.paymentFee(
                      context.read<PaymentBloc>().state.selectedPaymentMethod!))
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
            log(response.body);

            return response.body;
          } else {
            log(response.body);
            return (response.body);
          }
        } on http.BaseResponse catch (error) {
          log(error.toString());
          return error.toString();
        }
      default:
        return "Unknown payment method";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (BuildContext paymentContext, PaymentState state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: FilledButton(
            onPressed: state.selectedPaymentMethod != null
                ? () async {
                    LoadingScreen.instance().show(context: context);
                    await _createCharge(
                        context: context,
                        paymentMethod: context
                            .read<PaymentBloc>()
                            .state
                            .selectedPaymentMethod!,
                        onChargeCreated: (charge) {
                          LoadingScreen.instance().hide();
                          Navigator.pushNamed(
                              context, PromptPayScreen.routeName,
                              arguments: charge);
                        });
                  }
                : null,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              backgroundColor: state.selectedPaymentMethod == null
                  ? MaterialStateProperty.all<Color>(
                      const Color(0xFF5DB329).withAlpha(75),
                    )
                  : MaterialStateProperty.all<Color>(
                      const Color(0xFF5DB329),
                    ),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  "Proceed to Payment",
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String paymentMethodString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.promptPay:
        return "promptpay";
    }
  }
}
