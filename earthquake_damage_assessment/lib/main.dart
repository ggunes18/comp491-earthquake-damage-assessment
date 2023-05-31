import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earthquake_damage_assessment/pages/helper/home_page_helper.dart';
import 'package:earthquake_damage_assessment/pages/victim/home_page_victim.dart';
import 'package:earthquake_damage_assessment/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'pages/common/first_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = AuthService();
  var isLogin = false;
  var isVictim = false;
  var isHelper = false;

  checkIfLoggedIn() async {
    auth.authStateChanges.listen((User? user) async {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });

        // Retrieve user data from Firestore
        var userData = await FirebaseFirestore.instance
            .collection('UserTest')
            .doc(user.uid)
            .get();

        setState(() {
          isVictim = userData['isVictim'] ?? false;
          isHelper = userData['isHelper'] ?? false;
        });
      }
    });
  }

  @override
  void initState() {
    checkIfLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin
          ? isHelper
              ? const HelperHomePage()
              : const VictimHomePage()
          : const FirstPage(),
    );
  }
}
