import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earthquake_damage_assessment/pages/victim/home_page_buttons.dart';
import 'package:earthquake_damage_assessment/service/location_services.dart';
import 'package:earthquake_damage_assessment/service/safe_locations.dart';
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
List<SafeLocation> safeLocations = [];
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
      _searchController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VictimProfilePage()),
      );
    }
  }

  Future<Set<Marker>> createMarkers() async {
    List<SafeLocation> locationList = await getSafeLocations();

    Set<Marker> markerSet = {};
    int markerId = 1;

    for (SafeLocation location in locationList) {
      LatLng latLng =
          LatLng(location.location.latitude, location.location.longitude);

      Marker marker = Marker(
        markerId: MarkerId(markerId.toString()),
        position: latLng,
        infoWindow: InfoWindow(title: location.title),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      );

      markerSet.add(marker);
      markerId++;
    }

    return markerSet;
  }

  @override
  void initState() {
    super.initState();
    getLocation();

    createMarkers().then((markerSet) {
      setState(() {
        markers = markerSet;
      });
    });

    getSafeLocations().then((list) {
      setState(() {
        safeLocations = list;
      });
    });
  }

  void getLocation() async {
    Position position = await LocationService().getUserCurrentLocation();
    if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return WillPopScope(
      onWillPop: () async {
        // Disable the back button
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
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
                          _searchController.text = selectedLocation.title;
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
                          _searchController.text = result.title;
                          GeoPoint geoPoint = result.location;
                          LatLng latLng =
                              LatLng(geoPoint.latitude, geoPoint.longitude);
                          mapController
                              .animateCamera(CameraUpdate.newLatLng(latLng));
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
                      height: screenHeight * 0.52,
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
                      //const SizedBox(height: 20),
                      Container(
                        height: 30,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/scroll.png"),
                          ),
                        ),
                      ),

                      //List of buttons
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // Adjust the padding values as per your requirement
                              child: HomePageButton(
                                text: "INJURED",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // Adjust the padding values as per your requirement
                              child: HomePageButton(
                                text: "LOST",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // Adjust the padding values as per your requirement
                              child: HomePageButton(
                                text: "LOST RELATIVE",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // Adjust the padding values as per your requirement
                              child: HomePageButton(
                                text: "UNDER THE DEBRIS",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // Adjust the padding values as per your requirement
                              child: HomePageButton(
                                text: "REQUEST RESOURCE",
                              ),
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
            .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        final String name = suggestionsList[index].title;
        final String nameLowercase = name.toLowerCase();
        final String queryLowercase = query.toLowerCase();

        final int queryIndex = nameLowercase.indexOf(queryLowercase);
        return ListTile(
          onTap: () {
            GeoPoint geoPoint = suggestionsList[index].location;
            LatLng latLng = LatLng(geoPoint.latitude, geoPoint.longitude);
            // Move the camera to the selected location
            mapController.moveCamera(
              CameraUpdate.newLatLng(latLng),
            );
            query = suggestionsList[index].title;
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
      (location) => location.title.toLowerCase() == query.toLowerCase(),
    );

    if (selectedLocation != null) {
      GeoPoint geoPoint = selectedLocation.location;
      LatLng latLng = LatLng(geoPoint.latitude, geoPoint.longitude);
      mapController.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedLocation != null) {
        close(context, selectedLocation);
      } else {
        close(context, SafeLocation(const GeoPoint(0, 0), " "));
      }
    });
    return Container();
  }
}
