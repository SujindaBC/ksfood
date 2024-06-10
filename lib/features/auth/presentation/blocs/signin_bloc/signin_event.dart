part of 'signin_bloc.dart';

sealed class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object?> get props => [];
}

class VerifyPhoneNumber extends SigninEvent {
  const VerifyPhoneNumber({
    required this.phoneNumber,
    required this.verificationFailed,
    required this.codeSent,
    required this.timeout,
    required this.codeAutoRetrievalTimeout,
  });

  final String phoneNumber;
  final void Function(FirebaseAuthException verificationFailed)
      verificationFailed;
  final void Function(String, int?) codeSent;
  final Duration timeout;
  final void Function(String) codeAutoRetrievalTimeout;
}

class VerificationFailed extends SigninEvent {
  const VerificationFailed({
    required this.context,
    required this.exception,
  });

  final BuildContext context;
  final FirebaseAuthException exception;

  @override
  List<Object> get props => [context, exception];
}

class CodeSent extends SigninEvent {
  const CodeSent({
    required this.context,
    required this.verificationId,
    this.forceResendingToken,
    required this.timeout,
    required this.phoneNumberTextEdittingController,
  });

  final BuildContext context;
  final String verificationId;
  final int? forceResendingToken;
  final Duration timeout;
  final TextEditingController phoneNumberTextEdittingController;

  @override
  List<Object?> get props => [context, verificationId, forceResendingToken];
}

class CodeAutoRetrievalTimeout extends SigninEvent {
  const CodeAutoRetrievalTimeout({
    required this.context,
    required this.verificationId,
  });

  final BuildContext context;
  final String verificationId;

  @override
  List<Object> get props => [context, verificationId];
}
