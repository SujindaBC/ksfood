import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Placeholder(),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
            },
            leading: const Icon(
              Icons.receipt_long_outlined,
            ),
            title: const Text(
              "Order",
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
            },
            leading: const Icon(
              Icons.payment_outlined,
            ),
            title: const Text(
              "Payment Methods",
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
            },
            leading: const Icon(
              Icons.history_outlined,
            ),
            title: const Text(
              "History",
            ),
          ),
        ],
      ),
    );
  }
}
