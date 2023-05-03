import 'package:earthquake_damage_assessment/pages/editing_page.dart';
import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String biography = "Biography...";
String location = "Location";
String namesurname = "Name Surname";

class Save2 {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future<Map<String, String>> save() async {
    final currentUser = _firebaseAuth.currentUser;
    final docRef = _firestore.collection('UserTest').doc(currentUser?.uid);
    final docSnapshot = await docRef.get();
    final data = docSnapshot.data();

    String fetchedBiography = data?['Biography'] ?? "Biography...";
    String fetchedLocation = data?['Location'] ?? "Location";
    String fetchedNamesurname = data?['NameSurname'] ?? "Name Surname";

    return {
      'biography': fetchedBiography,
      'location': fetchedLocation,
      'namesurname': fetchedNamesurname,
    };
  }
}

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final save2 = Save2();
  late Future<Map<String, String>> fetchedData;

  @override
  void initState() {
    super.initState();
    fetchedData = fetchData();
  }

  Future<Map<String, String>> fetchData() async {
    Map<String, String> fetchedData = await save2.save();

    namesurname = fetchedData['namesurname']!;
    location = fetchedData['location']!;
    biography = fetchedData['biography']!;

    return fetchedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarButtons(context),
      body: FutureBuilder<Map<String, String>>(
        future: fetchedData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return body(snapshot.data!);
          }
        },
      ),
    );
  }
}

AppBar appBarButtons(context) {
  return AppBar(
    leading: BackButton(
      color: Colors.black,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditingPage()),
          );
        },
        icon: Icon(Icons.edit),
        color: Colors.black,
      )
    ],
  );
}

ListView body(Map<String, String> data) {
  return ListView(
    physics: BouncingScrollPhysics(),
    children: [
      profilePhoto(),
      SizedBox(
        height: 20,
      ),
      nameText(data['namesurname']!),
      locationText(data['location']!),
      SizedBox(
        height: 20,
      ),
      biography_text(data['biography']!),
      SizedBox(
        height: 20,
      ),
      iconButtons(),
      SizedBox(
        height: 20,
      ),
      Divider(
        color: Colors.black,
        height: 25,
        thickness: 1,
        indent: 25,
        endIndent: 25,
      ),
      SizedBox(
        height: 20,
      ),
      requests(),
    ],
  );
}

CircleAvatar profilePhoto() {
  return CircleAvatar(
    //backgroundImage: AssetImage("assets/images/profile_picture.png"),
    radius: 120,
  );
}

Center nameText(String namesurname) {
  return Center(
    child: Text(
      namesurname,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ),
  );
}

Center locationText(String location) {
  return Center(
    child: Text(
      location,
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
    ),
  );
}

Padding biography_text(String biography) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          biography,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

Row iconButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(onPressed: () {}, icon: Icon(Icons.local_phone)),
      IconButton(onPressed: () {}, icon: Icon(Icons.mail)),
    ],
  );
}

Container requests() {
  return Container(
    child: Column(children: [
      Text("Request 1 - (Request Type)"),
      Text("Adress"),
    ]),
  );
}
