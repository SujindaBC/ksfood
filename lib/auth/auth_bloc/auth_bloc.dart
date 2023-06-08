import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksfood/auth/auth_error.dart';
import 'package:ksfood/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({
    required this.authRepository,
  }) : super(const AuthUninitialized(isLoading: false)) {
    on<AutholizedEvent>(
      (event, emit) {
        emit(
          const AuthUninitialized(
            isLoading: true,
          ),
        );
        try {
          authRepository.signInWithVerificationCode(
            verificationId: event.verificationId,
            verificationCode: event.verificationCode,
          );
        } on FirebaseAuthException catch (e) {
          emit(
            UnAutholized(
              authError: AuthError.from(e),
              isLoading: false,
            ),
          );
        }
      },
    );
  }
}
