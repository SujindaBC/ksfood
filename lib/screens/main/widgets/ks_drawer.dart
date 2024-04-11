import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/auth/auth_bloc/auth_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return state.status == AuthStatus.authenticated
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            state.user?.phoneNumber ?? "",
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(SignoutRequestedEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              "Log Out",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
            },
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
