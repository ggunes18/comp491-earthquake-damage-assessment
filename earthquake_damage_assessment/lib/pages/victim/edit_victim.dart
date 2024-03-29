import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VictimSaveService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Void?> save(
      {required String nameSurname,
      required String location,
      required String phone,
      required String bloodType,
      required String emergencyPerson}) async {
    final currentUser = _firebaseAuth.currentUser;
    final docRef = _firestore.collection('UserTest').doc(currentUser?.uid);
    final docSnapshot = await docRef.get();
    final data = docSnapshot.data();
    final mail = data?['mail'];
    final password = data?['password'];
    final username = data?['userName'];
    final isHelper = data?['isHelper'];
    final isVictim = data?['isVictim'];
    final newData = {
      'mail': mail ?? data?['mail'],
      'password': password ?? data?['password'],
      'userName': username ?? data?['userName'],
      'isHelper': isHelper ?? data?['isHelper'],
      'isVictim': isVictim ?? data?['isVictim'],
      'nameSurname': nameSurname ?? data?['nameSurname'],
      'location': location ?? data?['location'],
      'phone': phone ?? data?['phone'],
      'bloodType': bloodType ?? data?['bloodType'],
      'emergencyPerson': emergencyPerson ?? data?['emergencyPerson'],
    };
    await docRef.set(newData);
  }
}
