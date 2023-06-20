import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/models/product.dart';
import 'package:ksfood/screens/product/product_screen.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    required this.merchantId,
    required this.product,
    this.note,
  });

  final String merchantId;
  final Product product;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = context.read<CartBloc>();
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return ListTile(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductScreen.routeName,
              arguments: {
                "merchantId": merchantId.toString().trim(),
                "product": product.toMap(),
              },
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
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
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
          title: Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          subtitle: Text(
            "฿${product.price.toStringAsFixed(2)}",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
          titleAlignment: ListTileTitleAlignment.center,
          // trailing: const Icon(
          //   Icons.arrow_forward_ios,
          //   size: 16.0,
          // ),
          trailing: state.status == CartStateStatus.loading
              ? const CupertinoActivityIndicator()
              : IconButton(
                  onPressed: () {
                    cartBloc.add(
                      AddProductToCart(
                        merchantId: merchantId,
                        product: product,
                        quantity: 1,
                        comment: note ?? "",
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
        );
      },
    );
  }
}
