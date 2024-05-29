import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/models/merchant.dart';
import 'package:ksfood/screens/merchant/widgets/products_list.dart';
import 'package:ksfood/widgets/appbar_action_cart_button.dart';

class MerchantScreen extends StatefulWidget {
  static const routeName = '/merchant';
  const MerchantScreen({super.key});

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  int quantity = 1;

  void retrieveQuantityFromQuantityButton(int newQuantityValue) {
    setState(() {
      quantity = newQuantityValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Merchant merchant = Merchant.fromMap(
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: const [
            AppBarActionCartButton(),
          ],
        ),
        body: SingleChildScrollView(
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
                      merchant.image,
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

              // Merchant name
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  merchant.name,
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
                      "(${merchant.rating.toStringAsFixed(1)})",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ),
              const Divider(
                indent: 12.0,
                endIndent: 12.0,
              ),
              const SizedBox(height: 8.0),
              ProductsList(merchant: merchant)
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.carts!.isEmpty) {
              return const SizedBox();
            } else {
              return FloatingActionButton(
                onPressed: () {},
                child: const AppBarActionCartButton(),
              );
            }
          },
        ),
      ),
    );
  }
}
