import 'dart:async';
import 'package:earthquake_damage_assessment/pages/helper/helper_map_marker.dart';
import 'package:earthquake_damage_assessment/service/location_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../service/helper_request.dart';
import 'helper_profile_page.dart';
import 'helper_request_page.dart';

class HelperHomePage extends StatefulWidget {
  const HelperHomePage({super.key});

  @override
  State<HelperHomePage> createState() => _HelperHomePageState();
}

class _HelperHomePageState extends State<HelperHomePage> {
  int _selectedIndex = 1;

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(41.2054283, 29.07241),
    zoom: 14,
  );

  late GoogleMapController mapController;
  Set<Marker> markers = {};
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HelperRequestPage()),
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
  void initState() {
    super.initState();
    fetchAndDisplayRequests();
  }

  void fetchAndDisplayRequests() async {
    getLocation();
    List<HelperRequest> requestList = await getAllRequests();
    for (var request in requestList) {
      // ignore: use_build_context_synchronously
      Marker marker = createMarker(
          context,
          request.location.latitude,
          request.location.longitude,
          request.emergency,
          request.userName,
          request.status,
          request);
      setState(() {
        markers.add(marker);
      });
    }
  }

  void getLocation() async {
    Position position = await LocationService().getUserCurrentLocation();
    setState(() {
      initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
      );
    });

    if (_controllerCompleter.isCompleted) {
      mapController.moveCamera(
        CameraUpdate.newCameraPosition(initialCameraPosition),
      );
    }

    // Fetch and display all requests again every time we update the location
    fetchAndDisplayRequests();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
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
          currentIndex: 1,
          selectedItemColor: const Color.fromRGBO(199, 0, 56, 0.89),
          onTap: _onItemTapped,
        ),
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                children: [
                  // AppName
                  Row(
                    children: const [
                      Text(
                        "KuHelp",
                        style: TextStyle(
                          color: Color.fromRGBO(199, 0, 56, 0.89),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 5),

                  // Map Integration
                  Container(
                    height: screenHeight * 0.87,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: initialCameraPosition,
                          markers: markers,
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: FloatingActionButton(
                              onPressed: () async {
                                Position position = await LocationService()
                                    .getUserCurrentLocation();
                                setState(() {
                                  initialCameraPosition = CameraPosition(
                                    target: LatLng(
                                        position.latitude, position.longitude),
                                    zoom: 15,
                                  );
                                  mapController.moveCamera(
                                    CameraUpdate.newCameraPosition(
                                        initialCameraPosition),
                                  );
                                  markers.clear();
                                  markers.add(Marker(
                                    markerId:
                                        const MarkerId("Current Location"),
                                    position: LatLng(
                                        position.latitude, position.longitude),
                                  ));
                                });
                              },
                              child: const Icon(Icons.location_searching),
                              hoverColor: Colors.white,
                              backgroundColor:
                                  const Color.fromRGBO(199, 0, 56, 0.89)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
