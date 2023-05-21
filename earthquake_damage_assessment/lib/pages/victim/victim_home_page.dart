import 'dart:async';
import 'package:earthquake_damage_assessment/pages/victim/home_page_buttons.dart';
import 'package:earthquake_damage_assessment/service/location_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'victim_profile_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:collection/collection.dart';

final TextEditingController _searchController = TextEditingController();

class VictimHomePage extends StatefulWidget {
  const VictimHomePage({super.key});

  @override
  State<VictimHomePage> createState() => _VictimHomePageState();
}

late GoogleMapController mapController;
Set<Marker> markers = {};
final Completer<GoogleMapController> _controllerCompleter = Completer();

class _VictimHomePageState extends State<VictimHomePage> {
  int _selectedIndex = 0;

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(41.2054283, 29.07241),
    zoom: 15,
  );

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

  final List<Marker> marker = [
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(41.206862, 29.072034),
      infoWindow: InfoWindow(
        title: "Safe Location 1",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("2"),
      position: LatLng(41.2054283, 29.07240),
      infoWindow: InfoWindow(
        title: "Safe Location 2",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("3"),
      position: LatLng(41.0848, 29.0510),
      infoWindow: InfoWindow(
        title: "Safe Location 3",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
  ];

  @override
  void initState() {
    super.initState();
    getLocation();
    markers.addAll(marker);
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
                      readOnly: false,
                      controller: _searchController,
                      onChanged: (value) async {
                        final selectedLocation = await showSearch(
                          context: context,
                          delegate: LocationSearch(safeLocations),
                          query: _searchController.text,
                        );
                        if (selectedLocation != null) {
                          _searchController.text = selectedLocation.name;
                        }
                      },
                      onTap: () async {
                        // Open the search bar and await the result
                        final result = await showSearch<SafeLocation>(
                          context: context,
                          delegate: LocationSearch(safeLocations),
                        );

                        if (result != null) {
                          // The user has selected a location, update the text field and move the camera
                          _searchController.text = result.name;
                          mapController.animateCamera(
                              CameraUpdate.newLatLng(result.coordinates));
                        }
                      },
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

                    //Google Map Api
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

class SafeLocation {
  final String name;
  final LatLng coordinates;

  SafeLocation(this.name, this.coordinates);
}

List<SafeLocation> safeLocations = [
  SafeLocation('Safe Location 1', LatLng(41.206862, 29.072034)),
  SafeLocation('Safe Location 2', LatLng(41.2054283, 29.07240)),
  SafeLocation('Safe Location 3', LatLng(41.0848, 29.0510)),
  // Add more locations as needed...
];

class LocationSearch extends SearchDelegate<SafeLocation> {
  final List<SafeLocation> safeLocations;

  LocationSearch(this.safeLocations);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          Navigator.pop(context);
          _searchController.clear();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
        query = '';
        _searchController.clear();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? safeLocations
        : safeLocations
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        final String name = suggestionsList[index].name;
        final String nameLowercase = name.toLowerCase();
        final String queryLowercase = query.toLowerCase();

        final int queryIndex = nameLowercase.indexOf(queryLowercase);
        return ListTile(
          onTap: () {
            // Move the camera to the selected location
            mapController.moveCamera(
              CameraUpdate.newLatLng(suggestionsList[index].coordinates),
            );
            query = suggestionsList[index].name;
            showResults(context);
          },
          title: queryIndex == -1
              ? Text(name)
              : RichText(
                  text: TextSpan(
                    text: name.substring(0, queryIndex),
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: name.substring(
                            queryIndex, queryIndex + queryLowercase.length),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            name.substring(queryIndex + queryLowercase.length),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
        );
      },
      itemCount: suggestionsList.length,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Find the selected location
    final SafeLocation? selectedLocation = safeLocations.firstWhereOrNull(
      (location) => location.name.toLowerCase() == query.toLowerCase(),
    );

    if (selectedLocation != null) {
      // Move the camera to the selected location
      mapController.animateCamera(
        CameraUpdate.newLatLng(selectedLocation.coordinates),
      );
    }

    // Close the search delegate
    // Close the search delegate
    if (selectedLocation != null) {
      close(context, selectedLocation);
    } else {
      close(context, SafeLocation('', LatLng(0, 0)));
    }
    return Container();
  }
}
