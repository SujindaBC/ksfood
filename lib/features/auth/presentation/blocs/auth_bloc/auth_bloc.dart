import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksfood/core/auth/auth_error.dart';
import 'package:ksfood/features/auth/domain/repositories/authentication_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final StreamSubscription authStreamSubscription;
  final AuthenticationRepository authRepository;
  AuthBloc({
    required this.authRepository,
  }) : super(AuthState.unknown()) {
    authStreamSubscription = authRepository.user.listen((User? user) {
      add(AuthEventChanged(user: user));
    });
    on<AuthEventChanged>((event, emit) {
      emit(state.copyWith(
        status: event.user == null
            ? AuthStatus.unauthenticated
            : AuthStatus.authenticated,
        user: event.user,
      ));
    });

    on<SignoutRequestedEvent>((event, emit) async {
      await authRepository.signOut();
    });
  }

  @override
  Future<void> close() {
    authStreamSubscription.cancel();
    return super.close();
  }
}
