import 'package:earthquake_damage_assessment/pages/home_page_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "profile_page.dart";
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
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
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color.fromRGBO(199, 0, 56, 0.89),
        ),
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // AppName
                  Row(
                    children: [
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

                  SizedBox(height: 20),

                  // search bar
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: "Search for Safe Location",
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.grey[600],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Map Integration

                  // Map Integration
                  Container(
                    height: 450,
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
                              label: Text('Locate me'),
                              icon: Icon(Icons.location_searching),
                              hoverColor: Colors.white,
                              backgroundColor:
                                  Color.fromRGBO(199, 0, 56, 0.89)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.grey[200],
                child: Center(
                  child: Column(children: [
                    //Heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Request Help",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    //List of buttons
                    Expanded(
                      child: ListView(
                        children: [
                          HomePageButton(
                            text: "INJURED",
                          ),
                          HomePageButton(
                            text: "LOST",
                          ),
                          HomePageButton(
                            text: "LOST RELATIVE",
                          ),
                          HomePageButton(
                            text: "UNDER THE DEBRIS",
                          ),
                          HomePageButton(
                            text: "REQUEST RESOURCE",
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            )
          ]),
        ));
  }
}
