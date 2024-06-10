import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  Stream<User?> get user;

  Future<void> verificationCompleted(
      PhoneAuthCredential phoneAuthCredential) async {}

  // Signin with phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(FirebaseAuthException verificationFailed)
        verificationFailed,
    required void Function(String, int? codeSent) codeSent,
    required Duration timeout,
    required void Function(String codeAutoRetrievalTimeout)
        codeAutoRetrievalTimeout,
  }) async {}

  // Signout
  Future<void> signOut();
}
