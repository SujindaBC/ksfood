import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksfood/models/product.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key, required this.merchantId});

  final String merchantId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("menu")
          .where("merchantId", isEqualTo: merchantId)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case (ConnectionState.active):
            if (snapshot.data == null) {
              return const Text("Null");
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
                ListView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final Product product = products[index];
                    return ListTile(
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
                      ),
                      titleAlignment: ListTileTitleAlignment.top,
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
