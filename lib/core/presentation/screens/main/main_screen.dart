import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/core/data/blocs/cart_bloc/cart_bloc.dart';
import 'package:ksfood/core/data/blocs/location_bloc/location_bloc.dart';
import 'package:ksfood/core/presentation/loading/loading_screen.dart';
import 'package:ksfood/core/presentation/screens/main/widgets/ads_slide.dart';
import 'package:ksfood/core/presentation/screens/main/widgets/automated_slide_card.dart';
import 'package:ksfood/core/presentation/screens/main/widgets/ks_drawer.dart';
import 'package:ksfood/core/presentation/screens/main/widgets/all_merchants.dart';
import 'package:ksfood/core/presentation/screens/main/widgets/process_order.dart';
import 'package:ksfood/core/presentation/widgets/appbar_action_cart_button.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/main';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoadingScreen.instance().hide();
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white.withAlpha(175),
            surfaceTintColor: Colors.transparent,
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
                BlocBuilder<LocationBloc, LocationState>(
                    builder: (context, state) {
                  if (state.placemark != null) {
                    return Text(
                      state.placemark?.street ?? "Loading",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 12),
                    );
                  } else {
                    return Text(
                      "Loading current location...",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 12),
                    );
                  }
                }),
              ],
            ),
            actions: const [],
          ),
          drawer: const AppDrawer(),
          body: const SingleChildScrollView(
            child: Column(
              children: [
                AdsSlide(),
                ProcessOrder(),
                SizedBox(height: 20.0),
                AutomatedSlideCard(),
                SizedBox(height: 20),
                AllMerchants(),
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
