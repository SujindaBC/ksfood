import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/models/payment_model.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Select payment method:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Card(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: PaymentMethod.values.length,
                  itemBuilder: (context, index) {
                    final paymentMethod = PaymentMethod.values[index];
                    return ListTile(
                      onTap: () {
                        context.read<PaymentBloc>().add(
                              SelectPaymentMethod(
                                paymentMethod: paymentMethod,
                              ),
                            );
                      },
                      title: Text(
                        paymentMethodToString(paymentMethod),
                      ),
                      horizontalTitleGap: 0.0,
                      contentPadding: const EdgeInsets.only(right: 12.0),
                      trailing: Image.asset(
                        paymentMethodIcons[paymentMethod]!,
                        scale: 4,
                      ),
                      leading: Radio<PaymentMethod>(
                        activeColor: Theme.of(context).primaryColor,
                        value: paymentMethod,
                        groupValue: state.selectedPaymentMethod,
                        onChanged: (value) {
                          context.read<PaymentBloc>().add(
                                SelectPaymentMethod(
                                  paymentMethod: value!,
                                ),
                              );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String paymentMethodToString(PaymentMethod method) {
    switch (method) {
      // case PaymentMethod.cashOnHand:
      //   return 'Cash';
      case PaymentMethod.promptPay:
        return 'PromptPay';
      case PaymentMethod.mobileBankingKBank:
        return 'Mobile Banking KBank';
      // case PaymentMethod.mobileBankingSCB:
      //   return 'Mobile Banking SCB';
    }
  }
}
