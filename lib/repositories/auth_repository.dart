import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  const AuthRepository({
    required this.firebaseAuth,
  });
  final FirebaseAuth firebaseAuth;

  Stream<User?> get user => firebaseAuth.userChanges();

  // Signin with phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential verificationCompleted)
        verificationCompleted,
    required void Function(FirebaseAuthException verificationFailed)
        verificationFailed,
    required void Function(String, int? codeSent) codeSent,
    required Duration timeout,
    required void Function(String codeAutoRetrievalTimeout)
        codeAutoRetrievalTimeout,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      timeout: timeout,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  // Signin with verification code
  Future<UserCredential> signInWithVerificationCode({
    required String verificationId,
    required String verificationCode,
  }) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: verificationCode,
    );
    return await firebaseAuth.signInWithCredential(credential);
  }

  // Signout
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
