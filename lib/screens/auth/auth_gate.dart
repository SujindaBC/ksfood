import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ksfood/blocs/auth/auth_bloc/auth_bloc.dart';
import 'package:ksfood/screens/auth/phone_auth_screen.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});
  static const routeName = "/auth-gate";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
      return WillPopScope(
        child: const Scaffold(
          body: SafeArea(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
        ),
        onWillPop: () async => false,
      );
    }, listener: (context, state) {
      log("${state.status}");
      if (state.status == AuthStatus.authenticated) {
        log("${state.status}");
      } else if (state.status == AuthStatus.unauthenticated) {
        log("${state.status}");
        Navigator.pushNamed(context, PhoneAuthScreen.routeName);
      }
    });
  }
}
