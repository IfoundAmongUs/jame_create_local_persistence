import 'package:firebase_auth/firebase_auth.dart';
import 'package:ch15/services/authentication_api.dart';

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  @override
  Future<String> currentUserUid() async {
    final User? user = await _firebaseAuth.currentUser;
    return user?.uid ?? '';
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signInWithEmailAndPassword(
      {String? email, String? password}) async {
    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email!, password: password!);
    final User user = userCredential.user!;
    return user.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword(
      {String? email, String? password}) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email!, password: password!);
    final User user = userCredential.user!;
    return user.uid;
  }

  @override
  Future<void> sendEmailVerification() async {
    final User? user = _firebaseAuth.currentUser;
    await user?.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    final User? user = _firebaseAuth.currentUser;
    return user?.emailVerified ?? false;
  }
}
