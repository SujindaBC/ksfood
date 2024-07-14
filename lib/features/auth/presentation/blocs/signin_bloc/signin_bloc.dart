import 'dart:developer' as developer;
import 'dart:developer';

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
import 'package:ksfood/features/auth/presentation/pages/phone_auth_screen.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final AuthenticationRepositoryImplementation
      authenticationRepositoryImplementation;
  SigninBloc({
    required this.authenticationRepositoryImplementation,
  }) : super(SigninState.initial()) {
    on<VerifyPhoneNumber>((event, emit) async {
      LoadingScreen.instance().show(context: event.context);
      developer.log("Verify phone number: ${DateTime.now().toIso8601String()}");
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
        LoadingScreen.instance().hide();
        emit(
          state.copyWith(
            status: SigninStateStatus.error,
          ),
        );
      }
    });

    on<CodeSent>((event, emit) {
      developer.log("Code sent: ${DateTime.now().toIso8601String()}");
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
      LoadingScreen.instance().hide();
      developer.log("Verification failed: ${DateTime.now().toIso8601String()}");
      final error = AuthError.from(event.exception);
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
      developer.log(
          "Code auto retrieval timeout: ${DateTime.now().toIso8601String()}");
      final AuthStatus authStatus = event.context.read<AuthBloc>().state.status;
      if (authStatus == AuthStatus.unauthenticated) {
        LoadingScreen.instance().hide();
        Navigator.pushNamed(event.context, PhoneAuthScreen.routeName);
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

    on<VerifyOTP>((event, emit) async {
      LoadingScreen.instance().show(context: event.context);
      emit(state.copyWith(status: SigninStateStatus.submitting));
      final PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
      );
      try {
        final UserCredential credential =
            await FirebaseAuth.instance.signInWithCredential(
          phoneAuthCredential,
        );
        log("User credential: ${credential.user?.uid}");
        emit(state.copyWith(status: SigninStateStatus.success));
        LoadingScreen.instance().hide();
      } on FirebaseAuthException catch (error) {
        log(error.toString());
        emit(state.copyWith(status: SigninStateStatus.error));
        LoadingScreen.instance().hide();
        showDialog(
          context: event.context,
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(error.message.toString()),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }
}
