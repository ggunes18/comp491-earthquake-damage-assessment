import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VictimRequest {
  String type;
  String status;
  GeoPoint location;
  String userName;
  VictimRequest(this.type, this.status, this.location, this.userName);
}

Future<List<VictimRequest>> getRequestVictim() async {
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  List<VictimRequest> requestList = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('RequestTest').get();

  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  requestList = documents.map((document) {
    String type = document['type'];
    String status = document['status'];
    GeoPoint location = document['location'];
    String userName = document['name'];

    return VictimRequest(type, status, location, userName);
  }).toList();

  return requestList;
}
