import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/models/cart_item.dart';
import 'package:ksfood/models/product.dart';

class CartItemSection extends StatelessWidget {
  const CartItemSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = context.read<CartBloc>();
    return BlocBuilder<CartBloc, CartState>(
      bloc: context.read<CartBloc>(),
      builder: (context, state) {
        switch (state.status) {
          case CartStateStatus.loaded || CartStateStatus.initial:
            if (state.items!.isEmpty) {
              return const Center(
                child: Text(
                  "No product in cart.",
                ),
              );
            }
            final List<CartItem> items = state.items!.map((doc) {
              return CartItem.fromMap(doc.toMap());
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Select to checkout:",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Merchant: #${state.merchantId.hashCode}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                // Radio(
                                //   toggleable: true,
                                //   value: true,
                                //   groupValue: state.merchantId,
                                //   onChanged: (value) {},
                                // )
                              ],
                            ),
                          ),
                          ListView.separated(
                            itemCount: state.items!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final Product item = items[index].product;
                              return ListTile(
                                onTap: () {},
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    8.0,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 3 / 2,
                                    child: Image.network(
                                      item.imageUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
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
                                title: Text(
                                  "x${items[index].quantity} ${item.name}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                subtitle: Text(
                                    "฿${(items[index].quantity * item.price).toStringAsFixed(2)}",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                titleAlignment: ListTileTitleAlignment.center,
                                trailing: PopupMenuButton<String>(
                                  onSelected: (String value) {
                                    if (value == 'delete') {
                                      cartBloc.add(
                                        RemoveProductFromCart(
                                          productId: item.id,
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(Icons.delete),
                                        title: Text('Delete Item'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 4.0);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
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
