// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'signin_cubit.dart';

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

  SigninState copyWith({
    SigninStatus? status,
  }) {
    return SigninState(
      status: status ?? this.status,
    );
  }
}

enum SigninStatus {
  initial,
  submitting,
  success,
  error,
}
