import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/blocs/payment_bloc/payment_bloc.dart';
import 'package:ksfood/models/payment_model.dart';
import 'package:ksfood/screens/checkout/widgets/proceed_button.dart';
import 'package:ksfood/screens/checkout/widgets/delivery_address_section.dart';
import 'package:ksfood/screens/checkout/widgets/payment_section.dart';

class CheckoutScreen extends StatelessWidget {
  static const routeName = "/checkout";
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(),
            body: const SingleChildScrollView(
              child: Column(
                children: [
                  DeliveryAddressSection(),
                  PaymentSection(),
                ],
              ),
            ),
            bottomSheet: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          const Text("Subtotal"),
                          const Spacer(),
                          Text(
                            "฿${state.subtotalPrice.toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<PaymentBloc, PaymentState>(
                      builder: (context, paymentState) {
                        if (paymentState.selectedPaymentMethod != null) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Text(
                                    "Payment Fee ${paymentMethodFee(context.read<PaymentBloc>().state.selectedPaymentMethod!)} "),
                                const Spacer(),
                                Text(
                                  "+ ฿${state.paymentFee(context.read<PaymentBloc>().state.selectedPaymentMethod!).toStringAsFixed(2)}",
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          const Text("Delivery Fee"),
                          const Spacer(),
                          Text(
                            "+ ฿${state.deliveryFee.toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          const Text("VAT 7%"),
                          const Spacer(),
                          Text(
                            "+ ฿${(state.vat).toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      indent: 12.0,
                      endIndent: 12.0,
                    ),
                    BlocBuilder<PaymentBloc, PaymentState>(
                      builder: (context, paymentState) {
                        return paymentState.selectedPaymentMethod != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  children: [
                                    const Text("Total"),
                                    const Spacer(),
                                    Text(
                                      "฿${(state.totalPrice + state.paymentFee(paymentState.selectedPaymentMethod!)).toStringAsFixed(2)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  children: [
                                    const Text("Total"),
                                    const Spacer(),
                                    Text(
                                      "฿${state.totalPrice.toStringAsFixed(2)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                    const SizedBox(height: 12.0),
                    const ProceedToPaymentButton(),
                    const SizedBox(height: 12.0),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
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
