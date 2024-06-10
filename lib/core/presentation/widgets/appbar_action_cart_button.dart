import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/core/data/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/core/presentation/screens/cart/cart_screen.dart';

class AppBarActionCartButton extends StatelessWidget {
  const AppBarActionCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int totalItemCount = 0;

        if (state.carts != null) {
          for (var cart in state.carts!) {
            totalItemCount += cart.items.fold(
                0, (previousValue, item) => previousValue + item.quantity);
          }
        }
        return Badge(
          label: Text(
            totalItemCount.toString(),
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
