import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/loading/loading_screen.dart';
import 'package:ksfood/screens/main/widgets/ads_slide.dart';
import 'package:ksfood/screens/main/widgets/ks_drawer.dart';

import '../../auth/auth_bloc/auth_bloc.dart';

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
        body: Column(
          children: [
            const AdsSlide(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Featured Merchants",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
