import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/order";
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Order screen"),
          ],
        ),
      ),
    ));
  }
}
