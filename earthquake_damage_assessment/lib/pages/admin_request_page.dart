import 'package:flutter/material.dart';

class AdminRequestPage extends StatefulWidget {
  AdminRequestPage({Key? key}) : super(key: key);

  @override
  _AdminRequestPageState createState() => _AdminRequestPageState();
}

class _AdminRequestPageState extends State<AdminRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Request Page"),
      ),
      body: Center(
        child: Text("Admin Request Page"),
      ),
    );
  }
}
