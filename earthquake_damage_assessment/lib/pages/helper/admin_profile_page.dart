import 'package:earthquake_damage_assessment/pages/helper/request_table_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_home_page.dart';
import '../victim/editing_page.dart';
import '../../service/auth.dart';
import '../common/login_page.dart';

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

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final save2 = Save2();
  late Future<Map<String, String>> fetchedData;
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RequestTablePage()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchedData = fetchData();
  }

  Future<Map<String, String>> fetchData() async {
    Map<String, String> fetchedData = await save2.save();

    namesurname = fetchedData['namesurname']!;
    location = fetchedData['location']!;

    return fetchedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logout(context);
        },
        backgroundColor: const Color.fromRGBO(199, 0, 56, 0.89),
        child: const Icon(Icons.logout_outlined),
      ),
      appBar: appBarButtons(context),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 2,
        selectedItemColor: const Color.fromRGBO(199, 0, 56, 0.89),
        onTap: _onItemTapped,
      ),
      body: FutureBuilder<Map<String, String>>(
        future: fetchedData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
    leading: const BackButton(
      color: Colors.black,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditingPage()),
          );
        },
        icon: const Icon(Icons.edit),
        color: Colors.black,
      )
    ],
  );
}

ListView body(Map<String, String> data) {
  return ListView(
    physics: const BouncingScrollPhysics(),
    children: [
      profilePhoto(),
      const SizedBox(
        height: 20,
      ),
      nameText(data['namesurname']!),
      locationText(data['location']!),
      const SizedBox(
        height: 20,
      ),
      //biography_text(data['biography']!),
      const SizedBox(
        height: 20,
      ),
      generalInfoPhoneMail("phoneNum", "mail"),
      generalInfoBloodSeconPerson("bloodType", "secondPerson"),
      const SizedBox(
        height: 20,
      ),
      const Divider(
        color: Colors.black,
        height: 25,
        thickness: 1,
        indent: 25,
        endIndent: 25,
      ),
      const SizedBox(
        height: 20,
      ),
      requests(),
    ],
  );
}

CircleAvatar profilePhoto() {
  return const CircleAvatar(
    //backgroundImage: AssetImage("assets/images/profile_picture.png"),
    radius: 120,
  );
}

Center nameText(String namesurname) {
  return Center(
    child: Text(
      namesurname,
      style: const TextStyle(
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
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
    ),
  );
}

Row generalInfoPhoneMail(phoneNum, mail) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.local_phone),
      Text(
        phoneNum,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      const SizedBox(
        width: 20,
      ),
      const Icon(Icons.mail),
      Text(
        mail,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    ],
  );
}

Row generalInfoBloodSeconPerson(bloodType, secondPerson) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.bloodtype),
      Text(
        bloodType,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      const SizedBox(
        width: 20,
      ),
      const Icon(Icons.account_box_rounded),
      Text(
        secondPerson,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    ],
  );
}

Container requests() {
  return Container(
    child: Column(children: const [
      Text("Request 1 - (Request Type)"),
      Text("Adress"),
    ]),
  );
}

Future<void> logout(context) async {
  await AuthService().signOut();
  Navigator.of(context).pushAndRemoveUntil(
    CupertinoPageRoute(builder: (context) => const LoginPage()),
    (_) => false,
  );
}
