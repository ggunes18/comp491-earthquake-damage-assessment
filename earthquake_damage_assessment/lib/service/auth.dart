import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Void?> logIn({required String mail, required String password}) async {
    var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: mail, password: password);
  }

  Future<Void?> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<Void?> signIn(
      {required String mail,
      required String userName,
      required String password}) async {
    var user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: mail, password: password);
  }
}
