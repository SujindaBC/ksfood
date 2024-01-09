import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksfood/repositories/auth_repository.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository authRepository;
  SigninCubit({
    required this.authRepository,
  }) : super(SigninState.initial());

  Future<void> verifyPhoneNumber(
      {required String phoneNumber,
      required void Function(FirebaseAuthException verificationFailed)
          verificationFailed,
      required void Function(String, int? codeSent) codeSent,
      required Duration timeout,
      required void Function(String codeAutoRetrievalTimeout)
          codeAutoRetrievalTimeout}) async {
    emit(state.copyWith(status: SigninStatus.submitting));
    try {
      authRepository.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        timeout: timeout,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      emit(state.copyWith(status: SigninStatus.success));
    } on FirebaseAuthException catch (error) {
      log("$error", error: error);
      emit(state.copyWith(status: SigninStatus.error));
    }
  }

  Future<void> signInWithCredential(String verificationId, smsCode) async {
    emit(state.copyWith(status: SigninStatus.submitting));
    try {
      final PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    } on FirebaseAuthException catch (error) {
      log("$error", error: error);
      emit(state.copyWith(status: SigninStatus.error));
    }
  }
}
