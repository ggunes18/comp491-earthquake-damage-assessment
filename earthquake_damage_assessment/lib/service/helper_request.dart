import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HelperRequest {
  String type;
  String status;
  String name;
  int emergency;
  GeoPoint location;
  String directions;
  String info;
  String need;
  String secondPerson;
  DocumentReference userID;
  DateTime time;
  String phone;
  String emergencyPerson;
  String userName;
  DocumentReference requestID;

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
      this.time,
      this.phone,
      this.emergencyPerson,
      this.userName,
      this.requestID);
}

Future<List<HelperRequest>> getAllRequests() async {
  List<HelperRequest> requestList = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('RequestTest').get();

  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  requestList = await Future.wait(documents.map((document) async {
    String type = document['type'];
    String status = document['status'];
    String name = document['name'];
    int emergency = document['emergency'];
    GeoPoint location = document['location'];
    String directions = document['directions'];
    String info = document['info'];
    String need = document['need'];
    String secondPerson = document['secondPerson'];
    DocumentReference userID = document['userID'];
    DateTime time = document['time'].toDate();
    DocumentReference requestID = document.reference;

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('UserTest')
        .doc(userID.id)
        .get();
    String phone = userSnapshot['phone'];
    String emergencyPerson = userSnapshot['emergencyPerson'];
    String userName = userSnapshot['userName'];

    return HelperRequest(
        type,
        status,
        name,
        emergency,
        location,
        directions,
        info,
        need,
        secondPerson,
        userID,
        time,
        phone,
        emergencyPerson,
        userName,
        requestID);
  }).toList());

  return requestList;
}

void updateRequestStatus(DocumentReference requestRef, String newStatus) async {
  await requestRef.update({'status': newStatus});
}
