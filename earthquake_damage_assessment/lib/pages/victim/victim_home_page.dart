import 'dart:async';
import 'package:earthquake_damage_assessment/pages/victim/home_page_buttons.dart';
import 'package:earthquake_damage_assessment/service/location_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'victim_profile_page.dart';
import 'package:geolocator/geolocator.dart';

class VictimHomePage extends StatefulWidget {
  const VictimHomePage({super.key});

  @override
  State<VictimHomePage> createState() => _VictimHomePageState();
}

class _VictimHomePageState extends State<VictimHomePage> {
  int _selectedIndex = 0;

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(41.2054283, 29.07241),
    zoom: 15,
  );

  late GoogleMapController mapController;
  Set<Marker> markers = {};
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VictimProfilePage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
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
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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

                    const SizedBox(height: 20),

                    // search bar
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: "Search for Safe Location",
                        prefixIcon: const Icon(Icons.search),
                        prefixIconColor: Colors.grey[600],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                            onMapCreated: (controller) {
                              _controllerCompleter.complete(controller);
                              mapController = controller;
                            },
                            markers: markers,
                            mapType: MapType.normal,
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
                                      target: LatLng(position.latitude,
                                          position.longitude),
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
                                      position: LatLng(position.latitude,
                                          position.longitude),
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
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(children: [
                      //Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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
                      const SizedBox(height: 20),

                      //List of buttons
                      Expanded(
                        child: ListView(
                          children: const [
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
          )),
    );
  }
}
