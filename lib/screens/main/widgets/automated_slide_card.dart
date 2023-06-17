import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ksfood/models/merchant.dart';
import 'package:ksfood/screens/merchant/merchant_screen.dart';

class AutomatedSlideCard extends StatelessWidget {
  const AutomatedSlideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("merchants").snapshots(),
        builder: (context, snapshot) {
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
                          "All merchants",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CarouselSlider(
                      items: List.generate(
                        snapshot.data?.docs.length ?? 3,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Badge(
                              label: const Text("Sale"),
                              offset: const Offset(-24, 8),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    MerchantScreen.routeName,
                                    arguments: Merchant.fromMap(
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>,
                                    ).toMap(),
                                  );
                                },
                                child: Container(
                                  width: 125,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withAlpha(50),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 2 / 2.5,
                                    child: Column(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1 / 1,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(7.0),
                                              topRight: Radius.circular(7.0),
                                            ),
                                            child: Image.network(
                                              snapshot.data?.docs[index]
                                                      ["image"] ??
                                                  "",
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                              errorBuilder:
                                                  (BuildContext context,
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
                                            snapshot.data?.docs[index]["name"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      options: CarouselOptions(
                        initialPage: 0,
                        padEnds: false,
                        height: 140,
                        viewportFraction: 0.35,
                        pageSnapping: true,
                        autoPlay: true,
                      ),
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
