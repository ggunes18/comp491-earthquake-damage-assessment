import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaveService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Void?> save(
      {required String namesurname,
      required String phone,
      required String mail}) async {
    final currentUser = _firebaseAuth.currentUser;
    final docRef = _firestore.collection('UserTest').doc(currentUser?.uid);
    final docSnapshot = await docRef.get();
    final data = docSnapshot.data();
    final mail = data?['mail'];
    final password = data?['password'];
    final username = data?['userName'];
    final newData = {
      'mail': mail ?? data?['mail'],
      'password': password ?? data?['password'],
      'userName': username ?? data?['userName'],
      'NameSurname': namesurname ?? data?['NameSurname'],
      'Location': phone ?? data?['Phone'],
      'Biography': mail ?? data?['Mail'],
    };
    await docRef.set(newData);
  }
}
