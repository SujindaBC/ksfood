import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksfood/auth/auth_error.dart';
import 'package:ksfood/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final StreamSubscription authStramSubscription;
  final AuthRepository authRepository;
  AuthBloc({
    required this.authRepository,
  }) : super(AuthState.initial()) {
    on<AuthEventChanged>(
      (event, emit) {
        authStramSubscription = authRepository.user.listen((User? user) {
          add(AuthEventChanged(user: user));
        });
        emit(
          state.copyWith(
            const AuthState(
              isLoading: true,
              status: AuthStatus.unauthenticated,
              user: null,
            ),
          ),
        );
        if (event.user != null) {
          emit(
            state.copyWith(
              AuthState(
                isLoading: false,
                status: AuthStatus.authenticated,
                user: event.user,
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              const AuthState(
                isLoading: false,
                status: AuthStatus.unauthenticated,
                user: null,
              ),
            ),
          );
        }
      },
    );
  }
}
