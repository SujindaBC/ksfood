import 'package:flutter/material.dart';

class QuantityButton extends StatefulWidget {
  const QuantityButton({super.key});

  @override
  State<QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  int quantity = 1;

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: decrement,
          child: Container(
            decoration: BoxDecoration(
              color: quantity == 1
                  ? Theme.of(context).primaryColor.withAlpha(75)
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8.0),
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
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        GestureDetector(
          onTap: increment,
          child: Container(
            decoration: BoxDecoration(
              color: quantity >= 1 ? Theme.of(context).primaryColor : null,
              borderRadius: BorderRadius.circular(8.0),
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
