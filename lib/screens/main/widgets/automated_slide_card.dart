import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ksfood/models/merchant.dart';
import 'package:ksfood/screens/merchant/merchant_screen.dart';

class AutomatedSlideCard extends StatelessWidget {
  const AutomatedSlideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("merchants")
            .where("isAvailable", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          final merchant = snapshot.data?.docs;

          switch (snapshot.connectionState) {
            case (ConnectionState.active):
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Nearby merchants",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  CarouselSlider(
                    items: List.generate(
                      merchant?.length ?? 0,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                MerchantScreen.routeName,
                                arguments: Merchant.fromMap(
                                  merchant?[index].data()
                                      as Map<String, dynamic>,
                                ).toMap(),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black.withAlpha(50),
                                ),
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(7.0),
                                        topRight: Radius.circular(7.0),
                                      ),
                                      child: Image.network(
                                        merchant?[index]["image"] ?? "",
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
                                  const SizedBox(height: 4.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Text(
                                      merchant?[index]["name"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RatingBarIndicator(
                                          rating: merchant?[index]["rating"]
                                              .toDouble(),
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 12.0,
                                          direction: Axis.horizontal,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          "${merchant?[index]['rating'].toStringAsFixed(1)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Text(
                                      "data",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    options: CarouselOptions(
                      height: 155,
                      initialPage: 0,
                      padEnds: false,
                      viewportFraction: 0.4,
                      pageSnapping: true,
                      autoPlay: true,
                    ),
                  ),
                ],
              );

            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        });
  }
}
