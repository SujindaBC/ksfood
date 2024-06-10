import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ksfood/core/auth/auth_error.dart';
import 'package:ksfood/core/helpers/format_phonenumber.dart';
import 'package:ksfood/core/presentation/loading/loading_screen.dart';
import 'package:ksfood/features/auth/data/repositories/authentication_repository_impl.dart';
import 'package:ksfood/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ksfood/features/auth/presentation/pages/otp_screen.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthenticationRepositoryImplementation
      authenticationRepositoryImplementation;
  SigninBloc({
    required this.authenticationRepositoryImplementation,
  }) : super(SigninState.initial()) {
    on<VerifyPhoneNumber>((event, emit) async {
      try {
        emit(
          state.copyWith(
            status: SigninStateStatus.submitting,
          ),
        );
        developer.log(state.toString());
        await authenticationRepositoryImplementation.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          verificationFailed: event.verificationFailed,
          codeSent: event.codeSent,
          timeout: event.timeout,
          codeAutoRetrievalTimeout: event.codeAutoRetrievalTimeout,
        );
        emit(
          state.copyWith(
            status: SigninStateStatus.success,
          ),
        );
      } catch (error) {
        emit(
          state.copyWith(
            status: SigninStateStatus.error,
          ),
        );
      }
    });

    on<CodeSent>((event, emit) {
      LoadingScreen.instance().hide();
      Navigator.pushNamed(
        event.context,
        OTPScreen.routeName,
        arguments: {
          "phone_number": formatPhoneNumber(
            event.phoneNumberTextEdittingController.text.trim(),
          ),
          "verificationId": event.verificationId,
          "duration": event.timeout,
        },
      );
    });
    on<VerificationFailed>((event, emit) {
      final error = AuthError.from(event.exception);
      LoadingScreen.instance().hide();
      showDialog(
        context: event.context,
        builder: (context) {
          return AlertDialog(
            title: Text(error.dialogTitle),
            content: Text(error.dialogContent),
          );
        },
      );
    });

    on<CodeAutoRetrievalTimeout>((event, emit) {
      final AuthStatus authStatus = event.context.read<AuthBloc>().state.status;
      if (authStatus == AuthStatus.unauthenticated) {
        LoadingScreen.instance().hide();
        Navigator.of(event.context).pop();
        showDialog(
          context: event.context,
          builder: (context) {
            return const Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Time out."),
                ],
              ),
            );
          },
        );
      }
    });
  }
}
