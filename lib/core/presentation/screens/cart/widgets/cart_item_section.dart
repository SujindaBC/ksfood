import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/core/data/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/core/data/models/cart_model.dart';

class CartItemSection extends StatefulWidget {
  const CartItemSection({super.key});

  @override
  State<CartItemSection> createState() => _CartItemSectionState();
}

class _CartItemSectionState extends State<CartItemSection> {
  String? selectedMerchantId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      bloc: context.read<CartBloc>(),
      builder: (context, state) {
        switch (state.status) {
          case CartStateStatus.loaded:
          case CartStateStatus.initial:
            if (state.carts!.isEmpty) {
              return const Center(
                child: Text(
                  "No product in cart.",
                ),
              );
            }

            final List<Cart> carts = state.carts!.map((doc) {
              return Cart.fromMap(doc.toMap());
            }).toList();

            log(carts.toString());

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final Cart cart = carts[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: selectedMerchantId == cart.merchant.id,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedMerchantId = cart.merchant.id;
                                  } else {
                                    selectedMerchantId = null;
                                  }
                                });
                              },
                            ),
                            Text(
                              "Merchant: ${cart.merchant.name}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ),
                                    child: SizedBox(
                                      height: 48,
                                      child: AspectRatio(
                                        aspectRatio: 3 / 2,
                                        child: Image.network(
                                          cart.items[index].product.imageUrl,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            return const Icon(Icons.error);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "฿${(cart.items[index].quantity * cart.items[index].product.price).toStringAsFixed(2)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        Text(
                                          "x${cart.items[index].quantity} ${cart.items[index].product.name}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    onSelected: (String value) {
                                      if (value == 'delete') {
                                        context.read<CartBloc>().add(
                                              RemoveProductFromCart(
                                                product:
                                                    cart.items[index].product,
                                                quantity:
                                                    cart.items[index].quantity,
                                              ),
                                            );
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                        ),
                                        height: kMinInteractiveDimension / 2,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.delete),
                                            SizedBox(width: 12.0),
                                            Text('Delete Item'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 12.0);
                          },
                          itemCount: cart.items.length,
                        ),
                      ],
                    ),
                  ],
                );
              },
              itemCount: carts.length,
            );

          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
