import 'package:earthquake_damage_assessment/pages/helper/helper_request_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'helper_home_page.dart';
import '../../service/auth.dart';
import '../common/login_page.dart';
import 'helper_editing_page.dart';

String nameSurname = "-";
String organization = "-";
String mail = "-";
String phone = "-";

class GetInfo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<Map<String, String>> getData() async {
    final currentUser = _firebaseAuth.currentUser;
    final docRef = _firestore.collection('UserTest').doc(currentUser?.uid);
    final docSnapshot = await docRef.get();
    final data = docSnapshot.data();

    String fetchedNameSurname = data?['nameSurname'] ?? nameSurname;
    String fetchedOrganization = data?['organization'] ?? organization;
    String fetchedMail = data?['mail'] ?? mail;
    String fetchedPhone = data?['phone'] ?? phone;

    return {
      'nameSurname': fetchedNameSurname,
      'organization': fetchedOrganization,
      'mail': fetchedMail,
      'phone': fetchedPhone,
    };
  }
}

class HelperProfilePage extends StatefulWidget {
  const HelperProfilePage({Key? key}) : super(key: key);

  @override
  _HelperProfilePageState createState() => _HelperProfilePageState();
}

class _HelperProfilePageState extends State<HelperProfilePage> {
  final getInfo = GetInfo();
  late Future<Map<String, String>> fetchedData;
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HelperRequestPage()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HelperHomePage()),
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

    nameSurname = fetchedData['nameSurname']!;
    mail = fetchedData['mail']!;
    phone = fetchedData['phone']!;
    organization = fetchedData['organization']!;
    return fetchedData;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelperHomePage()),
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
        ));
  }
}

AppBar appBarButtons(context) {
  return AppBar(
    leading: BackButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelperHomePage()),
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
            MaterialPageRoute(builder: (context) => const HelperEditingPage()),
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
      profilePhoto(data['organization']!),
      const SizedBox(
        height: 20,
      ),
      nameText(data['nameSurname']!),
      const SizedBox(
        height: 20,
      ),
      generalInfoPhoneMail(data['phone']!, data['mail']!),
      const SizedBox(
        height: 10,
      ),
      generalInfoOrganization(data['organization']!),
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
      )
    ],
  );
}

CircleAvatar profilePhoto(String organization) {
  String initials =
      organization.isNotEmpty == true ? organization[0].toUpperCase() : '';
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

Row generalInfoOrganization(organization) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.apartment_sharp),
      Text(
        organization,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      const SizedBox(
        width: 20,
      ),
    ],
  );
}

Future<void> logout(context) async {
  await AuthService().signOut();
  nameSurname = "-";
  organization = "-";
  mail = "-";
  phone = "-";
  Navigator.of(context).pushAndRemoveUntil(
    CupertinoPageRoute(builder: (context) => const LoginPage()),
    (_) => false,
  );
}
