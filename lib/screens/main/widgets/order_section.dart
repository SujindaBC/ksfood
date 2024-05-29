import 'package:flutter/material.dart';

class OrderSection extends StatelessWidget {
  const OrderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.black.withAlpha(50),
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Order No. #0000",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                "Status: pending",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.black38,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
