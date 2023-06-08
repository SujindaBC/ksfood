part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AutholizedEvent extends AuthEvent {
  const AutholizedEvent(this.verificationId, this.verificationCode);

  final String verificationId;
  final String verificationCode;

  @override
  List<Object> get props => [verificationId, verificationCode];
}

class UnAutholizedEvent extends AuthEvent {}

class AuthErrorEvent extends AuthEvent {
  const AuthErrorEvent(this.authError);

  final AuthError authError;

  @override
  List<Object> get props => [authError];
}
