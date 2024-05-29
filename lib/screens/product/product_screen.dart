import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/models/merchant.dart';
import 'package:ksfood/models/product.dart';
import 'package:ksfood/screens/merchant/widgets/quantity_button.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/product';
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _noteController = TextEditingController();
  int quantity = 1;

  void getQuantityFromQuantityButton(int newQuantityValue) {
    setState(() {
      quantity = newQuantityValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments == null) {
      // Handle case where arguments are null or invalid
      // For example, redirect to an error screen or display an error message
      return const SafeArea(
        child: Scaffold(
          body: Center(
            child: Text('Invalid arguments'),
          ),
        ),
      );
    }

    final Merchant merchant = arguments['merchant'] as Merchant;
    final Product product =
        Product.fromMap(arguments['product'] as Map<String, dynamic>);
    final CartBloc cartBloc = context.read<CartBloc>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            },
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            rating: 2.75,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 14.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            "(${product.rating.toStringAsFixed(1)})",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "฿${product.price.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    const Divider(
                      indent: 12.0,
                      endIndent: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 3.0),
                      child: Text(
                        "Product details",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 3.0),
                      child: Text(
                        "Description: ${product.description}",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.black38,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 3.0),
                      child: Text(
                        "Availability: ${product.isAvailable ? "In Stock" : "Out of Stock"}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.black38,
                            ),
                      ),
                    ),
                    const Divider(
                      indent: 12.0,
                      endIndent: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Others",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            " Optional",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Colors.black38,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Note to seller"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      autofocus: true,
                                      controller: _noteController,
                                      onSubmitted: (String? value) {
                                        setState(() {
                                          _noteController.text == value;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      textInputAction: TextInputAction.done,
                                      decoration: const InputDecoration(
                                        labelText: "Note to seller",
                                        hintText: "Example: No straw.",
                                      ),
                                    )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: const Text("Done"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: TextField(
                          controller: _noteController,
                          enabled: false,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Note to seller",
                            hintText: "Example: No straw.",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
            BottomSheet(
              enableDrag: false,
              onClosing: () {},
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 12.0,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: QuantityButton(
                          onQuantityChanged: getQuantityFromQuantityButton,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FilledButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          cartBloc.add(
                            AddProductToCart(
                              merchant: merchant,
                              product: product,
                              quantity: quantity,
                              note: "",
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF5DB329),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "Add ฿${(product.price * quantity).toStringAsFixed(2)} to cart",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
