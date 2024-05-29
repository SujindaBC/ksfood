import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/cart_bloc/cart_bloc.dart';
import '../../models/cart_model.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CartBloc, CartState>(
                bloc: context.read<CartBloc>(),
                builder: (BuildContext context, CartState state) {
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

                      // carts.sort( (a, b) => b.timeCreated.compareTo(a.timeCreated));

                      return ListView.separated(
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
                                      Radio<Cart>(
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: state.carts![index],
                                        groupValue: state.selectedCart,
                                        onChanged: (Cart? value) {
                                          if (value != null) {
                                            context.read<CartBloc>().add(
                                                  SelectCart(
                                                    selectedCart: value,
                                                  ),
                                                );
                                          }
                                        },
                                      ),
                                      Text(
                                        "#${cart.merchant.name}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24.0),
                                    child: ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8.0,
                                                ),
                                                child: SizedBox(
                                                  height: 48,
                                                  child: AspectRatio(
                                                    aspectRatio: 3 / 2,
                                                    child: Image.network(
                                                      cart.items[index].product
                                                          .imageUrl,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return const Center(
                                                          child:
                                                              CupertinoActivityIndicator(),
                                                        );
                                                      },
                                                      errorBuilder:
                                                          (BuildContext context,
                                                              Object error,
                                                              StackTrace?
                                                                  stackTrace) {
                                                        return const Icon(
                                                            Icons.error);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                    context
                                                        .read<CartBloc>()
                                                        .add(
                                                          RemoveProductFromCart(
                                                            product: cart
                                                                .items[index]
                                                                .product,
                                                            quantity: cart
                                                                .items[index]
                                                                .quantity,
                                                          ),
                                                        );
                                                  }
                                                },
                                                itemBuilder: (BuildContext
                                                        context) =>
                                                    <PopupMenuEntry<String>>[
                                                  const PopupMenuItem<String>(
                                                    value: 'delete',
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                    ),
                                                    height:
                                                        kMinInteractiveDimension /
                                                            2,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
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
                                  ),
                                  const SizedBox(height: 12.0)
                                ],
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            indent: 12.0,
                            endIndent: 12.0,
                          );
                        },
                        itemCount: carts.length,
                      );

                    default:
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                  }
                },
              )
            ],
          ),
        ),
        bottomSheet: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: FilledButton(
                      onPressed: state.selectedCart != null
                          ? () {
                              Navigator.pushNamed(
                                  context, CheckoutScreen.routeName,
                                  arguments: {
                                    "selectedCart": state.selectedCart,
                                    "merchant": state.selectedCart!.merchant
                                  });
                            }
                          : null,
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        backgroundColor: state.selectedCart == null
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
