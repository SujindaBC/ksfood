import 'package:flutter/material.dart';
import 'package:ksfood/loading/loading_screen.dart';
import 'package:ksfood/screens/main/widgets/ads_slide.dart';
import 'package:ksfood/screens/main/widgets/automated_slide_card.dart';
import 'package:ksfood/screens/main/widgets/ks_drawer.dart';
import 'package:ksfood/screens/main/widgets/nearby_merchants.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/main';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoadingScreen.instance().hide();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
      ),
    );
  }
}
