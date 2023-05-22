import 'package:earthquake_damage_assessment/pages/helper/helper_profile_page.dart';
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
                        children: [
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
                        child: DataTable(showCheckboxColumn: false, columns: [
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Place')),
                          DataColumn(label: Text('Urgeny')),
                          DataColumn(label: Text('Username')),
                        ], rows: [
                          //row 1
                          DataRow(
                            cells: [
                              DataCell(Text('Name')),
                              DataCell(Text('Place1')),
                              DataCell(Text('Urgency Level')),
                              DataCell(Text('Username')),
                            ],
                            onSelectChanged: (newValue) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RequestInformationPage()),
                              );
                            },
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
