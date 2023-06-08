import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/loading/loading_screen.dart';
import 'package:ksfood/screens/auth/phone_auth_screen.dart';

import '../../app_bloc/app_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<AppBloc, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state.appStatus == AppStatus.initial) {
            LoadingScreen.instance().show(
              context: context,
              text: "Loading...",
            );
          } else {
            LoadingScreen.instance().hide();
          }
        },
        builder: (BuildContext context, AppState state) {
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(state.appStatus.name),
                    const Spacer(),
                    FilledButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(
                            0xFF5DB329,
                          ),
                        ),
                      ),
                      onPressed: () {
                        LoadingScreen.instance().show(
                          context: context,
                          text: "Loading...",
                        );
                        Navigator.pushNamed(context, PhoneAuthScreen.routeName);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Get started',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
