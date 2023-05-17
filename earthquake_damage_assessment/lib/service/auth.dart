import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AuthService {
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Void?> logIn({required String mail, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: mail, password: password);
  }

  Future<Void?> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<Void?> signIn(
      {required String mail,
      required String userName,
      required String password,
      required bool isVictim,
      required bool isHelper}) async {
    var user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: mail, password: password);

    await _firestore.collection("UserTest").doc(user.user!.uid).set({
      "mail": mail,
      "userName": userName,
      "password": password,
      "isVictim": isVictim,
      "isHelper": isHelper
    });
  }
}
