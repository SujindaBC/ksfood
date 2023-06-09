part of 'signin_bloc.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class GetStert extends SigninEvent {}

class CodeSentEvent extends SigninEvent {}

class TimeOut extends SigninEvent {}

class Conpleted extends SigninEvent {}
