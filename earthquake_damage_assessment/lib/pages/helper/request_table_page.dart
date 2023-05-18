import 'package:earthquake_damage_assessment/pages/helper/admin_profile_page.dart';
import 'package:flutter/material.dart';
import 'admin_home_page.dart';

class RequestTablePage extends StatefulWidget {
  const RequestTablePage({super.key});

  @override
  State<RequestTablePage> createState() => _RequestTablePageState();
}

class _RequestTablePageState extends State<RequestTablePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminProfilePage()),
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
                      Container(
                        child: DataTable(
                            showCheckboxColumn: false,
                            columns: const [
                              DataColumn(label: Text('Type')),
                              DataColumn(label: Text('Place')),
                              DataColumn(label: Text('Urgeny')),
                            ],
                            rows: const [
                              DataRow(
                                cells: [
                                  DataCell(Text('Name')),
                                  DataCell(Text('Place1')),
                                  DataCell(Text('Urgency Level')),
                                ],
                              ),
                            ]),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
