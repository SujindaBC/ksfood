part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    required this.appStatus,
    required this.authStatus,
    this.authError,
    this.user,
  });

  final AppStatus appStatus;
  final AuthStatus authStatus;
  final AuthError? authError;
  final User? user;

  @override
  List<Object?> get props => [appStatus, authStatus, authError, user];

  factory AppState.initial() {
    return const AppState(
      appStatus: AppStatus.initial,
      authStatus: AuthStatus.unauthenticated,
    );
  }

  AppState copyWith({
    AppStatus? appStatus,
    AuthStatus? authStatus,
    AuthError? authError,
    User? user,
  }) {
    return AppState(
      appStatus: appStatus ?? this.appStatus,
      authStatus: authStatus ?? this.authStatus,
      authError: authError ?? this.authError,
      user: user ?? this.user,
    );
  }
}

enum AppStatus {
  initial,
  loading,
  completed,
  failed,
}

enum AuthStatus {
  unauthenticated,
  authenticated,
}
