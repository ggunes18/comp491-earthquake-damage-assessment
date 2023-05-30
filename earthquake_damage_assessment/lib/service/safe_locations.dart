import 'package:cloud_firestore/cloud_firestore.dart';

class SafeLocation {
  GeoPoint location;
  String title;

  SafeLocation(this.location, this.title);
}

Future<List<SafeLocation>> getSafeLocations() async {
  List<SafeLocation> locationList = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('SafeLocations').get();

  List<QueryDocumentSnapshot> documents = querySnapshot.docs;

  locationList = documents.map((document) {
    GeoPoint location = document['location'];
    String title = document['title'];

    return SafeLocation(location, title);
  }).toList();

  return locationList;
}
