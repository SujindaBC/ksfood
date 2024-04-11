import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/models/payment_model.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BlocBuilder<PaymentBloc, PaymentState>(
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
                      return PaymentListTile(paymentMethod: paymentMethod);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PaymentListTile extends StatelessWidget {
  const PaymentListTile({
    super.key,
    required this.paymentMethod,
  });

  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PaymentBloc>().add(
              SelectPaymentMethod(
                paymentMethod: paymentMethod,
              ),
            );
      },
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          return Row(
            children: [
              Radio<PaymentMethod>(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    paymentMethodToString(paymentMethod),
                  ),
                  Text(
                    paymentMethodFee(paymentMethod),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(
                  paymentMethodIcons[paymentMethod]!,
                  scale: 4,
                  errorBuilder: (context, error, stackTrace) {
                    return const Placeholder();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String paymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.promptPay:
        return "PromptPay";
      case PaymentMethod.mobileBankingKBank:
        return "Mobile Banking KBank";
    }
  }

  String paymentMethodFee(PaymentMethod paymentMethod) {
    switch (paymentMethod) {
      case PaymentMethod.promptPay:
        return '1.65%';
      case PaymentMethod.mobileBankingKBank:
        return '฿10.00';
    }
  }
}
