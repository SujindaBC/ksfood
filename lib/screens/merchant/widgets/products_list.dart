import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksfood/models/merchant.dart';
import 'package:ksfood/models/product.dart';
import 'package:ksfood/screens/product/product_screen.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({
    super.key,
    required this.merchant,
  });

  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("menu")
          .where("isAvailable", isEqualTo: true)
          .where("merchantId", isEqualTo: merchant.id)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.active):
            if (snapshot.data?.size == 0) {
              return const Center(child: Text("No product available."));
            }
            final List<Product> products = snapshot.data!.docs.map((doc) {
              return Product.fromMap(doc.data());
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "All Products",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  itemCount: products.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final Product product = products[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ProductScreen.routeName,
                          arguments: {
                            "merchant": merchant,
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
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16.0,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      indent: 12.0,
                      endIndent: 12.0,
                    );
                  },
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
