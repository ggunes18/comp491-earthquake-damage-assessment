import 'package:earthquake_damage_assessment/pages/admin_request_page.dart';
import 'package:flutter/material.dart';
import 'admin_home_page.dart';

class RequestTable extends StatefulWidget {
  const RequestTable({super.key});

  @override
  State<RequestTable> createState() => _RequestTableState();
}

class _RequestTableState extends State<RequestTable> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
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
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Requests',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromRGBO(199, 0, 56, 0.89),
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
                        ], rows: [
                          DataRow(
                            cells: [
                              DataCell(Text('Name')),
                              DataCell(Text('Place1')),
                              DataCell(Text('Urgency Level')),
                            ],
                            onSelectChanged: (newValue) {
                              print('row 1 pressed');
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
