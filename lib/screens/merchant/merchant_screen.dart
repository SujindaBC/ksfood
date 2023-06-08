import 'package:flutter/material.dart';

class MerchantScreen extends StatelessWidget {
  static const routeName = '/merchant';
  const MerchantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Merchant Screen'),
      ),
    );
  }
}
