part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState({
    required this.isLoading,
    this.authError,
  });

  final bool isLoading;
  final AuthError? authError;

  @override
  List<Object?> get props => [isLoading, authError];
}

class AuthUninitialized extends AuthState {
  const AuthUninitialized({
    required bool isLoading,
    AuthError? authError,
  }) : super(isLoading: false);
}

class Autholized extends AuthState {
  const Autholized({
    required bool isLoading,
    AuthError? authError,
  }) : super(isLoading: false);
}

class UnAutholized extends AuthState {
  const UnAutholized({
    required bool isLoading,
    AuthError? authError,
  }) : super(isLoading: false);
}
