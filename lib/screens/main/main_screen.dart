import 'package:flutter/material.dart';
import 'package:ksfood/loading/loading_screen.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/main';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoadingScreen.instance().hide();
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Main Screen'),
        ),
      ),
    );
  }
}
