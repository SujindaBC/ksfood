import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksfood/auth/auth_error.dart';
import 'package:ksfood/repositories/auth_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository authRepository;
  AppBloc({
    required this.authRepository,
  }) : super(AppState.initial()) {
    on<RequestVerificationCode>((event, emit) {
      emit(
        state.copyWith(
          appStatus: AppStatus.loading,
        ),
      );
      try {
        authRepository.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          verificationCompleted: (PhoneAuthCredential verificationCompleted) {
            emit(
              state.copyWith(
                appStatus: AppStatus.completed,
                authStatus: AuthStatus.authenticated,
              ),
            );
          },
          verificationFailed: (FirebaseAuthException verificationFailed) {
            emit(
              state.copyWith(
                appStatus: AppStatus.failed,
                authError: AuthError.from(verificationFailed),
              ),
            );
          },
          codeSent: (String verificationId, int? codeSent) {
            emit(
              state.copyWith(
                appStatus: AppStatus.completed,
              ),
            );
          },
          timeout: const Duration(seconds: 120),
          codeAutoRetrievalTimeout: (String codeAutoRetrievalTimeout) {},
        );
        emit(
          state.copyWith(
            appStatus: AppStatus.completed,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          state.copyWith(
            appStatus: AppStatus.failed,
            authError: AuthError.from(e),
          ),
        );
      }
    });
  }
}
