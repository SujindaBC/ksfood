import 'package:flutter/material.dart';
import 'package:ksfood/screens/cart/widgets/cart_item_section.dart';
import 'package:ksfood/screens/cart/widgets/continue_button.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.0),
              CartItemSection(),
            ],
          ),
        ),
        bottomSheet: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: ContinueButton(),
            ),
          ],
        ),
      ),
    );
  }
}
