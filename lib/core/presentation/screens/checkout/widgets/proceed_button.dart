import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/core/data/blocs/charge_bloc/charge_bloc.dart';
import 'package:ksfood/core/data/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/features/merchant/data/models/merchant.dart';
import 'package:ksfood/core/presentation/loading/loading_screen.dart';
import 'package:ksfood/core/presentation/screens/promptpay/promptpay_screen.dart';

class ProceedToPaymentButton extends StatelessWidget {
  final Merchant merchant;

  const ProceedToPaymentButton({
    required this.merchant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, paymentState) {
        final chargeBloc = context.read<ChargeBloc>();

        return BlocListener<ChargeBloc, ChargeState>(
          listener: (context, chargeState) {
            if (chargeState.status == ChargeStatus.pending) {
              LoadingScreen.instance().show(context: context);
            } else {
              LoadingScreen.instance().hide();
              if (chargeState.status == ChargeStatus.successful) {
                Navigator.pushNamed(
                  context,
                  PromptPayScreen.routeName,
                  arguments:
                      chargeState.responseBody, // Pass the response body here
                );
              } else if (chargeState.status == ChargeStatus.failed) {
                // Show error message or handle failure
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Charge failed')));
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: FilledButton(
              onPressed: paymentState.selectedPaymentMethod != null &&
                      chargeBloc.state.status != ChargeStatus.pending
                  ? () {
                      chargeBloc.add(CreateCharge(
                        context: context,
                        paymentMethod: paymentState.selectedPaymentMethod!,
                        merchant: merchant,
                      ));
                    }
                  : null,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                backgroundColor: paymentState.selectedPaymentMethod == null
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
          ),
        );
      },
    );
  }
}
