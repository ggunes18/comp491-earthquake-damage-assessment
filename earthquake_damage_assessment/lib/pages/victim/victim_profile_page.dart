import 'package:earthquake_damage_assessment/pages/victim/victim_editing_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'victim_home_page.dart';
import '../../service/auth.dart';
import '../common/login_page.dart';

String userName = "-";
String mail = "-";
String nameSurname = "-";
String location = "-";
String phone = "-";
String bloodType = "-";
String emergencyPerson = "-";

class GetInfo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Map<String, String>> getData() async {
    final currentUser = _firebaseAuth.currentUser;
    final docRef = _firestore.collection('UserTest').doc(currentUser?.uid);
    print("docRef");
    print(docRef);
    final docSnapshot = await docRef.get();
    final data = docSnapshot.data();

    String fetchedUserName = data?['userName'] ?? userName;
    String fetchedMail = data?['mail'] ?? mail;
    String fetchedLocation = data?['location'] ?? location;
    String fetchedNameSurname = data?['nameSurname'] ?? nameSurname;
    String fetchedPhone = data?['phone'] ?? phone;
    String fetchedBloodType = data?['bloodType'] ?? bloodType;
    String fetchedEmergencyPerson = data?['emergencyPerson'] ?? emergencyPerson;

    return {
      'userName': fetchedUserName,
      'mail': fetchedMail,
      'nameSurname': fetchedNameSurname,
      'location': fetchedLocation,
      'phone': fetchedPhone,
      'bloodType': fetchedBloodType,
      'emergencyPerson': fetchedEmergencyPerson
    };
  }
}

class VictimProfilePage extends StatefulWidget {
  const VictimProfilePage({Key? key}) : super(key: key);

  @override
  _VictimProfilePageState createState() => _VictimProfilePageState();
}

class _VictimProfilePageState extends State<VictimProfilePage> {
  final getInfo = GetInfo();
  late Future<Map<String, String>> fetchedData;
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VictimHomePage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchedData = fetchData();
  }

  Future<Map<String, String>> fetchData() async {
    Map<String, String> fetchedData = await getInfo.getData();

    userName = fetchedData['userName']!;
    mail = fetchedData['mail']!;
    location = fetchedData['location']!;
    nameSurname = fetchedData['nameSurname']!;
    phone = fetchedData['phone']!;
    bloodType = fetchedData['bloodType']!;
    emergencyPerson = fetchedData['emergencyPerson']!;

    return fetchedData;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VictimHomePage()),
          );
          return true;
        },
        child: Scaffold(
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
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: 1,
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
        ));
  }
}

AppBar appBarButtons(context) {
  return AppBar(
    leading: BackButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VictimHomePage()),
        );
      },
      color: Colors.black,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VictimEditingPage()),
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
      profilePhoto(data['userName']!),
      const SizedBox(
        height: 20,
      ),
      nameText(data['nameSurname']!),
      locationText(data['location']!),
      const SizedBox(
        height: 20,
      ),
      const SizedBox(
        height: 20,
      ),
      generalInfoPhoneMail(data['phone']!, data['mail']!),
      const SizedBox(
        height: 10,
      ),
      generalInfoBloodSeconPerson(data['bloodType']!, data['emergencyPerson']!),
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

CircleAvatar profilePhoto(String username) {
  String initials =
      username.isNotEmpty == true ? username[0].toUpperCase() : '';
  return CircleAvatar(
    backgroundColor: const Color.fromRGBO(199, 0, 56, 0.89),
    radius: 120,
    child: Text(
      initials,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 60,
      ),
    ),
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
      Text("Status"),
    ]),
  );
}

Future<void> logout(context) async {
  await AuthService().signOut();
  userName = "-";
  mail = "-";
  nameSurname = "-";
  location = "-";
  phone = "-";
  bloodType = "-";
  emergencyPerson = "-";
  Navigator.of(context).pushAndRemoveUntil(
    CupertinoPageRoute(builder: (context) => const LoginPage()),
    (_) => false,
  );
}
