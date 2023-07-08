import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/screens/checkout/checkout_screen.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: FilledButton(
            onPressed: state.carts!.isNotEmpty
                ? () {
                    Navigator.pushNamed(context, CheckoutScreen.routeName);
                  }
                : null,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              backgroundColor: state.carts!.isEmpty
                  ? MaterialStateProperty.all<Color>(
                      const Color(0xFF5DB329).withAlpha(75),
                    )
                  : MaterialStateProperty.all<Color>(
                      const Color(0xFF5DB329),
                    ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: state.carts!.isEmpty ? null : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
