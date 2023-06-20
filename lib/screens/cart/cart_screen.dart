import 'package:flutter/material.dart';
import 'package:ksfood/screens/cart/widgets/cart_item_section.dart';
import 'package:ksfood/screens/cart/widgets/delivery_address_section.dart';
import 'package:ksfood/screens/cart/widgets/payment_section.dart';
import 'package:ksfood/screens/cart/widgets/proceed_button.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DeliveryAddressSection(),
              const SizedBox(height: 12.0),
              const CartItemSection(),
              const SizedBox(height: 8.0),
              const PaymentSection(),
              const SizedBox(height: 12.0),
              ProceedToPaymentButton(),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
