import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HelperRequest {
  String type;
  String status;
  String name;
  double emergency;
  GeoPoint location;
  String directions;
  String info;
  String need;
  String secondPerson;
  DocumentReference userID;
  Timestamp time;

  HelperRequest(
      this.type,
      this.status,
      this.name,
      this.emergency,
      this.location,
      this.directions,
      this.info,
      this.need,
      this.secondPerson,
      this.userID,
      this.time);
}

Future<List<HelperRequest>> getAllRequests() async {
  List<HelperRequest> requestList = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('RequestTest').get();

  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  requestList = documents.map((document) {
    String type = document['type'];
    String status = document['status'];
    String name = document['name'];
    double emergency = document['emergency'];
    GeoPoint location = document['location'];
    String directions = document['directions'];
    String info = document['info'];
    String need = document['need'];
    String secondPerson = document['secondPerson'];
    DocumentReference userID = document['userID'];
    Timestamp time = document['time'];

    return HelperRequest(type, status, name, emergency, location, directions,
        info, need, secondPerson, userID, time);
  }).toList();

  return requestList;
}

void updateRequestStatus(HelperRequest request) {
  ////
}
