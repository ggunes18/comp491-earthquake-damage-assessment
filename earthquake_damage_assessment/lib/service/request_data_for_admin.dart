import 'dart:ffi';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VictimRequest {
  String type;
  String status;
  String name;
  Int emergency;
  GeoPoint location;
  String directions;
  String info;
  String need;
  String secondPerson;
  String userID;
  DateTime time;

  VictimRequest(
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
  //String phoneNumber;
  //String emergencyContact;
  Reference userID;
  DateTime time;

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
      this.userID,
      this.time);
}

Future<List<VictimRequest>> getAllRequests() async {
  List<VictimRequest> requestList = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('RequestTest').get();

  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
  requestList = documents.map((document) {
    String type = document['type'];
    String status = document['status'];
    String name = document['name'];
    Int emergency = document['emergency'];
    GeoPoint location = document['location'];
    String directions = document['directions'];
    String info = document['info'];
    String need = document['need'];
    String secondPerson = document['secondPerson'];
    String userID = document['userID'];
    DateTime time = document['time'];

    return VictimRequest(type, status, name, emergency, location, directions,
        info, need, secondPerson, userID, time);
  }).toList();

  return requestList;
}
