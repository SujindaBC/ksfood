import 'dart:math' show cos, sqrt, asin;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart'; // Add geolocator package

import 'package:ksfood/models/merchant.dart';
import 'package:ksfood/screens/merchant/merchant_screen.dart';

class AutomatedSlideCard extends StatelessWidget {
  const AutomatedSlideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _determinePosition(),
      builder: (context, positionSnapshot) {
        if (positionSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }

        final userPosition = positionSnapshot.data;

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("merchants")
              .where("isAvailable", isEqualTo: true)
              .limit(5)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final merchantDocs = snapshot.data?.docs ?? [];

            // Calculate distances and sort merchants
            merchantDocs.sort((a, b) {
              final aLat = (a.data())["latitude"] as double?;
              final aLng = (a.data())["longitude"] as double?;
              final bLat = (b.data())["latitude"] as double?;
              final bLng = (b.data())["longitude"] as double?;

              if (aLat != null &&
                  aLng != null &&
                  bLat != null &&
                  bLng != null) {
                final distanceToA = _calculateDistance(
                    userPosition!.latitude, userPosition.longitude, aLat, aLng);
                final distanceToB = _calculateDistance(
                    userPosition.latitude, userPosition.longitude, bLat, bLng);

                return distanceToA.compareTo(distanceToB);
              }

              // Return 0 if any latitude or longitude is null
              return 0;
            });

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
                    merchantDocs.length,
                    (index) {
                      final merchantData = merchantDocs[index].data();
                      final merchant = Merchant.fromMap(merchantData);
                      final merchantLat = merchant.latitude;
                      final merchantLng = merchant.longitude;

                      final distance = _calculateDistance(
                          userPosition!.latitude,
                          userPosition.longitude,
                          merchantLat.toDouble(),
                          merchantLng.toDouble());

                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              MerchantScreen.routeName,
                              arguments: merchant.toMap(),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black.withAlpha(50),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
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
                                      merchant.image,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CupertinoActivityIndicator(),
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
                                    merchant.name,
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
                                        rating: merchant.rating.toDouble(),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 12.0,
                                        direction: Axis.horizontal,
                                      ),
                                      Text(
                                        " ${merchant.rating.toStringAsFixed(1)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: Colors.black45,
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    "${distance.toStringAsFixed(1)} km",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
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
          },
        );
      },
    );
  }

  Future<Position> _determinePosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  double _calculateDistance(
      double userLat, double userLng, double merchantLat, double merchantLng) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((merchantLat - userLat) * p) / 2 +
        cos(userLat * p) *
            cos(merchantLat * p) *
            (1 - cos((merchantLng - userLng) * p)) /
            2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }
}
