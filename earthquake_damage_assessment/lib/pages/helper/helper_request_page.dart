import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earthquake_damage_assessment/pages/helper/helper_profile_page.dart';
import 'package:earthquake_damage_assessment/service/request_data.dart';
import 'package:flutter/material.dart';
import 'helper_home_page.dart';
import 'request_info_page.dart';

class HelperRequestPage extends StatefulWidget {
  const HelperRequestPage({super.key});

  @override
  State<HelperRequestPage> createState() => _HelperRequestPageState();
}

class _HelperRequestPageState extends State<HelperRequestPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HelperHomePage()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HelperProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
          currentIndex: 0,
          selectedItemColor: const Color.fromRGBO(199, 0, 56, 0.89),
          onTap: _onItemTapped,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            "KuHelp - Request Page",
                            style: TextStyle(
                              color: Color.fromRGBO(199, 0, 56, 0.89),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      requestDataTable(context)
                    ],
                  ))
            ],
          ),
        ));
  }
}

Container requestDataTable(BuildContext context) {
  final List<HelperRequest> requestList = [
    HelperRequest(
        "name1",
        "type1",
        2,
        GeoPoint(37.7749, -122.4194),
        "directions1",
        "info1",
        "need1",
        "secondPerson1",
        "received",
        "userID1"),
    HelperRequest("name2", "type2", 3, GeoPoint(37.7749, -122.4194),
        "directions2", "info2", "need2", "secondPerson2", "received", "userID2")
  ];

  requestList.sort((a, b) => b.emergency - a.emergency);

  return Container(
    child: DataTable(
      showCheckboxColumn: false,
      columns: const [
        DataColumn(label: Text('Type')),
        DataColumn(label: Text('Place')),
        DataColumn(label: Text('Urgency')),
        DataColumn(label: Text('Username')),
      ],
      rows: requestList.map((request) {
        return DataRow(
          cells: [
            DataCell(Text(request.type)),
            DataCell(Text(request.location.toString())),
            DataCell(Text(request.emergency.toString())),
            DataCell(Text(request.name)),
          ],
          onSelectChanged: (newValue) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RequestInformationPage(helperRequest: request)),
            );
          },
        );
      }).toList(),
    ),
  );
}
