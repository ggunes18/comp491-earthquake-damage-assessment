import 'package:earthquake_damage_assessment/pages/helper/helper_profile_page.dart';
import 'package:flutter/material.dart';
import 'helper_home_page.dart';
import 'request_info_page.dart';
import '../../service/helper_request.dart';

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
                      FutureBuilder<Container>(
                        future: requestDataTable(context),
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

Future<Container> requestDataTable(BuildContext context) async {
  final List<HelperRequest> requestList = await getAllRequests();
  requestList.sort((a, b) => b.emergency.toInt() - a.emergency.toInt());

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
