import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'admin_profile_page.dart';
import 'request_table_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RequestTablePage()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminProfilePage()),
      );
    }
  }

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  late GoogleMapController mapController;
  Set<Marker> markers = {};

  Future<Position> getUserCurrentLocation() async {
    bool serviceEnables;
    LocationPermission permission;

    serviceEnables = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnables) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
          currentIndex: _selectedIndex,
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
                    height: 735,
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
                          child: FloatingActionButton.extended(
                              onPressed: () async {
                                Position position =
                                    await getUserCurrentLocation();
                                mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(position.latitude,
                                          position.longitude),
                                      zoom: 15,
                                    ),
                                  ),
                                );
                                markers.clear();
                                markers.add(Marker(
                                    markerId:
                                        const MarkerId("Current Location"),
                                    position: LatLng(position.latitude,
                                        position.longitude)));
                                setState(() {});
                              },
                              label: const Text('Locate me'),
                              icon: const Icon(Icons.location_searching),
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
