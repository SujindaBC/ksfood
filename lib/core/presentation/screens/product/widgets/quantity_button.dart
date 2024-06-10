import 'package:flutter/material.dart';
import 'package:ksfood/core/theme/app_pallete.dart';

class QuantityButton extends StatefulWidget {
  const QuantityButton({super.key, required this.onQuantityChanged});

  final ValueChanged<int> onQuantityChanged;

  @override
  State<QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  int quantity = 1;

  void increment() {
    setState(() {
      quantity++;
      widget.onQuantityChanged(quantity);
    });
  }

  void decrement() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        widget.onQuantityChanged(quantity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: decrement,
          child: Container(
            decoration: BoxDecoration(
              color: quantity == 1
                  ? AppPallete.secondary.withAlpha(50)
                  : AppPallete.secondary,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.remove,
                size: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "$quantity",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        GestureDetector(
          onTap: increment,
          child: Container(
            decoration: BoxDecoration(
              color: quantity >= 1 ? AppPallete.secondary : null,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                size: 16.0,
                color: quantity >= 1 ? Colors.white : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
