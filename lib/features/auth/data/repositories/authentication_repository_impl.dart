import 'package:firebase_auth/firebase_auth.dart';
import 'package:ksfood/features/auth/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<User?> get user => firebaseAuth.userChanges();

  @override
  Future<void> verificationCompleted(
      PhoneAuthCredential phoneAuthCredential) async {}

  @override
  Future<void> verifyPhoneNumber(
      {required String phoneNumber,
      required void Function(FirebaseAuthException verificationFailed)
          verificationFailed,
      required void Function(String p1, int? codeSent) codeSent,
      required Duration timeout,
      required void Function(String codeAutoRetrievalTimeout)
          codeAutoRetrievalTimeout}) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      timeout: timeout,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }
}
