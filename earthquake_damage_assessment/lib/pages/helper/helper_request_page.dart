import 'package:earthquake_damage_assessment/pages/helper/helper_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _sortByEmergency = false;
  bool _sortByDate = false;
  bool _filterByType = false;
  bool _filterByStatus = false;
  List<String> _selectedTypes = [];
  List<String> _selectedStatus = [];

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

  void _sortListByEmergency() {
    setState(() {
      _sortByEmergency = true;
      _sortByDate = false;
    });
  }

  void _sortListByDate() {
    setState(() {
      _sortByEmergency = false;
      _sortByDate = true;
    });
  }

  void _toggleTypeFilter(bool? value) {
    setState(() {
      _filterByType = value ?? false;
    });
  }

  void _toggleStatusFilter(bool? value) {
    setState(() {
      _filterByStatus = value ?? false;
    });
  }

  void _applyTypeFilter(bool value, String type) {
    setState(() {
      if (value) {
        _selectedTypes.add(type);
      } else {
        _selectedTypes.remove(type);
      }
    });
  }

  void _applyStatusFilter(bool value, String status) {
    setState(() {
      if (value) {
        _selectedStatus.add(status);
      } else {
        _selectedStatus.remove(status);
      }
    });
  }

  Future<Container> requestDataTable(BuildContext context) async {
    List<HelperRequest> requestList = await getAllRequests();

    if (_sortByEmergency) {
      requestList.sort((a, b) => b.emergency.toInt() - a.emergency.toInt());
    } else if (_sortByDate) {
      requestList.sort((b, a) => a.time.compareTo(b.time));
    }

    if (_filterByType) {
      requestList = requestList
          .where((request) => _selectedTypes.contains(request.type))
          .toList();
    }

    if (_filterByStatus) {
      requestList = requestList
          .where((request) => _selectedStatus.contains(request.status))
          .toList();
    }

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _sortListByEmergency,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        _sortByEmergency
                            ? const Color.fromRGBO(199, 0, 56, 0.89)
                            : Colors.grey,
                      ),
                    ),
                    child: Text('Sort by Emergency'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _sortListByDate,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        _sortByDate
                            ? const Color.fromRGBO(199, 0, 56, 0.89)
                            : Colors.grey,
                      ),
                    ),
                    child: Text('Sort by Date'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor:
                          const Color.fromRGBO(199, 0, 56, 0.89),
                      checkboxTheme: CheckboxThemeData(
                        fillColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromRGBO(199, 0, 56, 0.89),
                        ),
                      ),
                    ),
                    child: Checkbox(
                      value: _filterByType,
                      onChanged: _toggleTypeFilter,
                    ),
                  ),
                  const Text('Filter by Type:'),
                  const SizedBox(width: 8),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor:
                          const Color.fromRGBO(199, 0, 56, 0.89),
                      checkboxTheme: CheckboxThemeData(
                        fillColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromRGBO(199, 0, 56, 0.89),
                        ),
                      ),
                    ),
                    child: Checkbox(
                      value: _filterByStatus,
                      onChanged: _toggleStatusFilter,
                    ),
                  ),
                  const Text('Filter by Status:'),
                ],
              ),
            ),
            if (_filterByType)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: Text('INJURED'),
                      selected: _selectedTypes.contains('INJURED'),
                      onSelected: (value) => _applyTypeFilter(value, 'INJURED'),
                    ),
                    FilterChip(
                      label: Text('LOST'),
                      selected: _selectedTypes.contains('LOST'),
                      onSelected: (value) => _applyTypeFilter(value, 'LOST'),
                    ),
                    FilterChip(
                      label: Text('LOST RELATIVE'),
                      selected: _selectedTypes.contains('LOST RELATIVE'),
                      onSelected: (value) =>
                          _applyTypeFilter(value, 'LOST RELATIVE'),
                    ),
                    FilterChip(
                      label: Text('UNDER THE DEBRIS'),
                      selected: _selectedTypes.contains('UNDER THE DEBRIS'),
                      onSelected: (value) =>
                          _applyTypeFilter(value, 'UNDER THE DEBRIS'),
                    ),
                    FilterChip(
                      label: Text('REQUEST RESOURCE'),
                      selected: _selectedTypes.contains('REQUEST RESOURCE'),
                      onSelected: (value) =>
                          _applyTypeFilter(value, 'REQUEST RESOURCE'),
                    ),
                  ],
                ),
              ),
            if (_filterByStatus)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: Text('received'),
                      selected: _selectedStatus.contains('received'),
                      onSelected: (value) =>
                          _applyStatusFilter(value, 'received'),
                    ),
                    FilterChip(
                      label: Text('on progress'),
                      selected: _selectedStatus.contains('on progress'),
                      onSelected: (value) =>
                          _applyStatusFilter(value, 'on progress'),
                    ),
                    FilterChip(
                      label: Text('completed'),
                      selected: _selectedStatus.contains('completed'),
                      onSelected: (value) =>
                          _applyStatusFilter(value, 'completed'),
                    ),
                  ],
                ),
              ),
            ...requestList.map((request) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RequestInformationPage(helperRequest: request),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: ${request.type}'),
                          Text('Status: ${request.status}'),
                          Text('Urgency: ${request.emergency.toString()}'),
                          Text('Time: ${request.time.toString()}'),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Disable the back button
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return false;
        },
        child: Scaffold(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Text(
                          "KuHelp",
                          style: TextStyle(
                            color: Color.fromRGBO(199, 0, 56, 0.89),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                ),
              ),
            ),
          ),
        ));
  }
}
