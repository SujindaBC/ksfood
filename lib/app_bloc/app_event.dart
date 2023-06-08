part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class RequestVerificationCode extends AppEvent {
  const RequestVerificationCode({
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyPhoneNumber extends AppEvent {
  const VerifyPhoneNumber({
    required this.verificationId,
    required this.verificationCode,
  });

  final String verificationId;
  final String verificationCode;

  @override
  List<Object> get props => [verificationId, verificationCode];
}

class SignOut extends AppEvent {}
