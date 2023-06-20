import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/models/payment_model.dart';
import 'package:ksfood/screens/checkout/checkout_screen.dart';
import 'package:ksfood/screens/promptpay/promptpay_screen.dart';

class ProceedToPaymentButton extends StatelessWidget {
  const ProceedToPaymentButton({super.key});

  void _navigateToPaymentMethodScreen(
      BuildContext context, PaymentMethod paymentMethod) {
    // Navigate to the appropriate payment method screen based on the selected payment method
    switch (paymentMethod) {
      case PaymentMethod.promptPay:
        Navigator.pushNamed(
          context,
          PromptPayScreen.routeName,
        );
        break;
      case PaymentMethod.mobileBankingKBank:
        Navigator.pushNamed(
          context,
          CheckoutScreen.routeName,
        );
        break;
      default:
        // Handle unknown payment method
        break;
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
                    _navigateToPaymentMethodScreen(
                        context, state.selectedPaymentMethod!);
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
}
