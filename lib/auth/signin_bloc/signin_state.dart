part of 'signin_bloc.dart';

class SigninState extends Equatable {
  const SigninState({
    required this.status,
  });

  final SigninStatus status;

  factory SigninState.initial() {
    return const SigninState(
      status: SigninStatus.initial,
    );
  }

  @override
  List<Object> get props => [status];
}

enum SigninStatus {
  initial,
  loading,
  loaded,
  error,
}
