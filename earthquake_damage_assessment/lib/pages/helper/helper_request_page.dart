import 'package:earthquake_damage_assessment/pages/helper/helper_profile_page.dart';
import 'package:flutter/material.dart';
import 'helper_home_page.dart';
import 'request_info_page.dart';
import '../../service/request_data_for_admin.dart';

class HelperRequestPage extends StatefulWidget {
  const HelperRequestPage({super.key});

  @override
  State<HelperRequestPage> createState() => _HelperRequestPageState();
}

Future<Container> requestsTable() async {
  final List<VictimRequest> requestList = await getAllRequests();
//requesttime, location, directions, needs, name, id, phone number
  return Container(
    child: DataTable(
      columns: const [
        DataColumn(
            label: Expanded(
                child: Text(
          'Request',
          textAlign: TextAlign.center,
        ))),
        DataColumn(
            label: Expanded(
                child: Text(
          'Type',
          textAlign: TextAlign.center,
        ))),
        DataColumn(
            label: Expanded(
                child: Text(
          'Status',
          textAlign: TextAlign.center,
        ))),
        DataColumn(
            label: Expanded(
                child: Text(
          'Name',
          textAlign: TextAlign.center,
        ))),
        DataColumn(
            label: Expanded(
                child: Text(
          'Emergency',
          textAlign: TextAlign.center,
        ))),
        DataColumn(
            label: Expanded(
                child: Text(
          'Location',
          textAlign: TextAlign.center,
        ))),
        DataColumn(
            label: Expanded(
                child: Text(
          'Direction',
          textAlign: TextAlign.center,
        ))),
        DataColumn(
            label: Expanded(
                child: Text(
          'Info',
          textAlign: TextAlign.center,
        ))),
        DataColumn(
            label: Expanded(
                child: Text(
          'Need',
          textAlign: TextAlign.center,
        ))),
        DataColumn(
            label: Expanded(
                child: Text(
          'Second Person',
          textAlign: TextAlign.center,
        ))),
        DataColumn(
            label: Expanded(
                child: Text(
          'userID',
          textAlign: TextAlign.center,
        ))),
      ],
      rows: requestList.map((request) {
        final index = requestList.indexOf(request) + 1;
        return DataRow(
          cells: [
            DataCell(Center(child: Text('Request $index'))),
            DataCell(Center(child: Text(request.type))),
            DataCell(Center(child: Text(request.status))),
            DataCell(Center(child: Text(request.name))),
            DataCell(Center(child: Text(request.emergency as String))),
            DataCell(Center(child: Text(request.location as String))),
            DataCell(Center(child: Text(request.directions))),
            DataCell(Center(child: Text(request.info))),
            DataCell(Center(child: Text(request.need))),
            DataCell(Center(child: Text(request.secondPerson))),
            DataCell(Center(child: Text(request.userID))),
            DataCell(Center(child: Text(request.time as String))),
            //DataCell(Center(child: Text(request.requestID))),
          ],
        );
      }).toList(),
    ),
  );
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
                      ),
                      FutureBuilder<Container>(
                        future: requestsTable(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return snapshot.data!;
                          }
                        },
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
