part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    required this.isLoading,
    required this.status,
    this.user,
    this.authError,
  });

  final bool isLoading;
  final AuthStatus status;
  final User? user;
  final AuthError? authError;

  factory AuthState.initial() {
    return const AuthState(
      isLoading: false,
      status: AuthStatus.unauthenticated,
    );
  }

  @override
  List<Object?> get props => [isLoading, user, authError];

  AuthState copyWith(
    AuthState authState, {
    bool? isLoading,
    AuthStatus? status,
    User? user,
    AuthError? authError,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      user: user ?? this.user,
      authError: authError ?? this.authError,
    );
  }
}

enum AuthStatus {
  unauthenticated,
  authenticated,
  unknown,
}
