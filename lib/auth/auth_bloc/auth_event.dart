part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthEventChanged extends AuthEvent {
  const AuthEventChanged({this.user});

  final User? user;

  @override
  List<Object?> get props => [user];
}
