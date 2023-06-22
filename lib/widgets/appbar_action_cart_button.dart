import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/screens/cart/cart_screen.dart';

class AppBarActionCartButton extends StatelessWidget {
  const AppBarActionCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Badge(
          label: Text(
            state.carts!.length.toString(),
          ),
          isLabelVisible: state.carts!.isNotEmpty,
          offset: const Offset(-5, 5),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                CartScreen.routeName,
              );
            },
            icon: const Icon(
              Icons.shopping_bag_outlined,
            ),
          ),
        );
      },
    );
  }
}
