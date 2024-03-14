import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/models/payment_model.dart';
import 'package:ksfood/screens/checkout/checkout_screen.dart';
import 'package:http/http.dart' as http;

class ProceedToPaymentButton extends StatelessWidget {
  const ProceedToPaymentButton({
    super.key,
  });

  Future<String> _createCharge(
    BuildContext context,
    PaymentMethod paymentMethod,
  ) async {
    // Navigate to the appropriate payment method screen based on the selected payment method
    switch (paymentMethod) {
      case PaymentMethod.promptPay:
        try {
          final Uri url = Uri.parse("https://api.omise.co/charges");
          const String secreatKey = "skey_test_5nxdvpc87vwsrpu6zgo";
          final String amount = (context.read<CartBloc>().state.totalPrice +
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
              'amount': "${double.parse(amount) * 100}",
              'currency': 'THB',
              "source[type]": paymentMethodString(paymentMethod),
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
            log(response.body);
            return response.body;
          } else {
            return (response.body);
          }
        } on http.BaseResponse catch (error) {
          log(error.toString());
          return error.toString();
        }
      case PaymentMethod.mobileBankingKBank:
        Navigator.pushNamed(
          context,
          CheckoutScreen.routeName,
        );
        return " ";
      default:
        // Handle unknown payment method
        return " ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: FilledButton(
            onPressed: state.selectedPaymentMethod != null
                ? () {
                    _createCharge(
                      context,
                      context.read<PaymentBloc>().state.selectedPaymentMethod!,
                    );
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
      case PaymentMethod.mobileBankingKBank:
        return "mobile_banking_kbank";
    }
  }
}
