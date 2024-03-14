import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ksfood/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/loading/loading_screen.dart';
import 'package:ksfood/screens/main/widgets/ads_slide.dart';
import 'package:ksfood/screens/main/widgets/automated_slide_card.dart';
import 'package:ksfood/screens/main/widgets/ks_drawer.dart';
import 'package:ksfood/screens/main/widgets/nearby_merchants.dart';
import 'package:ksfood/widgets/appbar_action_cart_button.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/main';
  const MainScreen({super.key});

  Future<Placemark> _getFormattedAddress(BuildContext context) async {
    const String countryCode = "th";

    final Position currentPositon = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPositon.latitude,
        currentPositon.longitude,
        localeIdentifier: countryCode,
      );
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        return place;
      }
    } catch (error) {
      log("$error", error: error);
    }

    return Placemark();
  }

  @override
  Widget build(BuildContext context) {
    LoadingScreen.instance().hide();
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "KS Food",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                FutureBuilder(
                    future: _getFormattedAddress(context),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          "Loading...",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 12),
                        );
                      } else if (snapshot.hasData) {
                        final Placemark placemark = snapshot.data!;
                        return Text(
                          placemark.street ?? "Loading...",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 12),
                        );
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
            actions: const [],
          ),
          drawer: const AppDrawer(),
          body: const SingleChildScrollView(
            child: Column(
              children: [
                AdsSlide(),
                SizedBox(height: 20.0),
                AutomatedSlideCard(),
                SizedBox(height: 20),
                NearbyMerchants(),
                SizedBox(height: 25.0),
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
      ),
    );
  }
}
