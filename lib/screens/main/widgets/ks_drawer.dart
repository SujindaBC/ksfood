import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/auth/auth_bloc/auth_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                FilledButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignoutRequestedEvent());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Log out"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.red,
                    ),
                  ),
                )
              ],
            ),
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
