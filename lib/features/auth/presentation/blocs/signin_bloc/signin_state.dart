// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'signin_bloc.dart';

class SigninState extends Equatable {
  const SigninState({
    required this.status,
  });

  final SigninStateStatus status;

  factory SigninState.initial() {
    return const SigninState(
      status: SigninStateStatus.initial,
    );
  }

  @override
  List<Object> get props => [status];

  SigninState copyWith({
    SigninStateStatus? status,
  }) {
    return SigninState(
      status: status ?? this.status,
    );
  }

  @override
  bool get stringify => true;
}

enum SigninStateStatus {
  initial,
  submitting,
  success,
  error,
}
