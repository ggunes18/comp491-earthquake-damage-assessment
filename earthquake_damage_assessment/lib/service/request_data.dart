import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VictimRequest {
  String type;
  String status;

  VictimRequest(this.type, this.status);
}

class HelperRequest {
  String name;
  String type;
  Int emergency;
  GeoPoint location;
  String directions;
  String info;
  String need;
  String secondPerson;
  String status;
  Reference userID;

  HelperRequest(
      this.name,
      this.type,
      this.emergency,
      this.location,
      this.directions,
      this.info,
      this.need,
      this.secondPerson,
      this.status,
      this.userID);
}

Future<List<VictimRequest>> getRequestVictim() async {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  List<VictimRequest> requestList = [];

  if (currentUserId != null) {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('RequestTest')
        .where('userID',
            isEqualTo: FirebaseFirestore.instance
                .collection('UserTest')
                .doc(FirebaseAuth.instance.currentUser?.uid))
        .get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    requestList = documents.map((document) {
      String type = document['type'];
      String status = document['status'];

      return VictimRequest(type, status);
    }).toList();
  }

  return requestList;
}
