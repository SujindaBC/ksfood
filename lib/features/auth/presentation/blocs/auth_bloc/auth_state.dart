// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    required this.user,
    this.authError,
  });

  final AuthStatus status;
  final User? user;
  final AuthError? authError;

  factory AuthState.unknown() {
    return const AuthState(
      status: AuthStatus.unknown,
      user: null,
    );
  }

  @override
  List<Object?> get props => [status, user, authError];

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    AuthError? authError,
  }) {
    return AuthState(
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
