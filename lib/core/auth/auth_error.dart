import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Map<String, AuthError> authErrorMapping = {
  'invalid-phone-number': InvalidPhoneNumber(),
  'invalid-verification-code': InvalidVerificationCode(),
  'invalid-verification-id': InvalidVerificationId(),
  'session-expired': SessionExpired(),
  'too-many-requests': TooManyRequests(),
  'user-disabled': UserDisabled(),
  'user-not-found': UserNotFound(),
  'wrong-password': WrongPassword(),
};

abstract class AuthError extends Equatable {
  const AuthError({
    required this.dialogTitle,
    required this.dialogContent,
  });

  final String dialogTitle;
  final String dialogContent;

  factory AuthError.from(FirebaseAuthException exception) {
    return authErrorMapping[exception.code] ?? const UnknownAuthError();
  }

  @override
  List<Object?> get props => [dialogTitle, dialogContent];
}

class UnknownAuthError extends AuthError {
  const UnknownAuthError()
      : super(
          dialogTitle: 'Unknown authentication error',
          dialogContent:
              'An unknown authentication error has occurred. Please try again.',
        );
}

class InvalidPhoneNumber extends AuthError {
  const InvalidPhoneNumber()
      : super(
          dialogTitle: 'Invalid phone number',
          dialogContent: 'The phone number you entered is invalid.',
        );
}

class InvalidVerificationCode extends AuthError {
  const InvalidVerificationCode()
      : super(
          dialogTitle: 'Invalid verification code',
          dialogContent: 'The verification code you entered is invalid.',
        );
}

class InvalidVerificationId extends AuthError {
  const InvalidVerificationId()
      : super(
          dialogTitle: 'Invalid verification ID',
          dialogContent: 'The verification ID you entered is invalid.',
        );
}

class SessionExpired extends AuthError {
  const SessionExpired()
      : super(
          dialogTitle: 'Session expired',
          dialogContent: 'The session has expired. Please try again.',
        );
}

class TooManyRequests extends AuthError {
  const TooManyRequests()
      : super(
          dialogTitle: 'Too many requests',
          dialogContent:
              'Too many requests have been made from this device. Please try again later.',
        );
}

class UserDisabled extends AuthError {
  const UserDisabled()
      : super(
          dialogTitle: 'User disabled',
          dialogContent: 'This user has been disabled.',
        );
}

class UserNotFound extends AuthError {
  const UserNotFound()
      : super(
          dialogTitle: 'User not found',
          dialogContent: 'This user does not exist.',
        );
}

class WrongPassword extends AuthError {
  const WrongPassword()
      : super(
          dialogTitle: 'Wrong password',
          dialogContent: 'The password you entered is incorrect.',
        );
}
