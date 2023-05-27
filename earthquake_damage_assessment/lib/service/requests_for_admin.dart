import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VictimRequest {
  String type;
  String status;
  GeoPoint location;
  String userName;
  int emergencylevel;
  VictimRequest(this.type, this.status, this.location, this.userName,
      this.emergencylevel);
}

Future<List<VictimRequest>> getRequestVictim() async {
  List<VictimRequest> requestList = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('RequestTest').get();

  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  requestList = documents.map((document) {
    String type = document['type'];
    String status = document['status'];
    GeoPoint location = document['location'];
    String userName = document['name'];
    int emergencylevel = (document['emergency'] as num).toInt();

    return VictimRequest(type, status, location, userName, emergencylevel);
  }).toList();

  return requestList;
}
