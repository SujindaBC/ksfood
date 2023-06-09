import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/loading/loading_screen.dart';

import '../../auth/auth_bloc/auth_bloc.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/main';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoadingScreen.instance().hide();
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Text('Main Screen'),
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) => Text(
                  state.user?.uid ?? "Null",
                ),
                listener: (context, state) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
