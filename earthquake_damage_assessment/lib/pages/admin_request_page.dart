import 'package:earthquake_damage_assessment/pages/admin_home_page.dart';
import 'package:earthquake_damage_assessment/pages/profile_page.dart';
import 'package:flutter/material.dart';

class AdminRequestPage extends StatefulWidget {
  const AdminRequestPage({Key? key}) : super(key: key);

  @override
  _AdminRequestPageState createState() => _AdminRequestPageState();
}

class _AdminRequestPageState extends State<AdminRequestPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Request Page"),
      ),
      body: const Center(
        child: Text("Admin Request Page"),
      ),
    );
  }
}
