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
      position: LatLng(41.0284, 28.5870),
      infoWindow: InfoWindow(
        title: "Büyükçekmece Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("2"),
      position: LatLng(40.8490, 29.1233),
      infoWindow: InfoWindow(
        title: "Adalar Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("3"),
      position: LatLng(41.185915, 28.729731),
      infoWindow: InfoWindow(
        title: "Arnavutköy Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("4"),
      position: LatLng(40.9800, 29.0999),
      infoWindow: InfoWindow(
        title: "Ataşehir Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("5"),
      position: LatLng(41.145317, 29.086227),
      infoWindow: InfoWindow(
        title: "Beykoz Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("6"),
      position: LatLng(41.0390, 28.9845),
      infoWindow: InfoWindow(
        title: "Beyoğlu Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("7"),
      position: LatLng(41.0157, 29.1018),
      infoWindow: InfoWindow(
        title: "Çekmeköy Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("8"),
      position: LatLng(41.0141, 28.5354),
      infoWindow: InfoWindow(
        title: "Esenler Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("9"),
      position: LatLng(41.0336, 28.4020),
      infoWindow: InfoWindow(
        title: "Esenyurt Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("10"),
      position: LatLng(41.089278, 28.923708),
      infoWindow: InfoWindow(
        title: "Eyüp Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("11"),
      position: LatLng(41.007324, 28.978153),
      infoWindow: InfoWindow(
        title: "Fatih Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("12"),
      position: LatLng(41.1145, 28.5920),
      infoWindow: InfoWindow(
        title: "Gaziosmanpaşa Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("13"),
      position: LatLng(40.5839, 29.0516),
      infoWindow: InfoWindow(
        title: "Kadıköy Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("14"),
      position: LatLng(40.5416, 29.1028),
      infoWindow: InfoWindow(
        title: "Kartal Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("15"),
      position: LatLng(40.5954, 28.4658),
      infoWindow: InfoWindow(
        title: "Küçükçekmece Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("16"),
      position: LatLng(40.939390, 29.131630),
      infoWindow: InfoWindow(
        title: "Maltepe Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("17"),
      position: LatLng(40.5224, 29.1908),
      infoWindow: InfoWindow(
        title: "Pendik Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("19"),
      position: LatLng(41.106727, 29.017327),
      infoWindow: InfoWindow(
        title: "Sarıyer Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("20"),
      position: LatLng(41.0354, 28.1659),
      infoWindow: InfoWindow(
        title: "Silivri Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("21"),
      position: LatLng(40.5717, 29.1644),
      infoWindow: InfoWindow(
        title: "Sultanbeyli Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("22"),
      position: LatLng(41.0641, 28.5217),
      infoWindow: InfoWindow(
        title: "Sultangazi Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("23"),
      position: LatLng(41.17755978, 29.62314785),
      infoWindow: InfoWindow(
        title: "Şile Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("26"),
      position: LatLng(41.030254, 29.105804),
      infoWindow: InfoWindow(
        title: "Ümraniye Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("27"),
      position: LatLng(41.012825, 29.051967),
      infoWindow: InfoWindow(
        title: "Üsküdar Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("28"),
      position: LatLng(41.0037, 28.5456),
      infoWindow: InfoWindow(
        title: "Zeytinburnu Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
    Marker(
      markerId: MarkerId("30"),
      position: LatLng(40.5726, 28.4957),
      infoWindow: InfoWindow(
        title: "Bakırköy Acil Toplanma Alanı",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    )
  ];

  @override
  void initState() {
    super.initState();
    getLocation();
    markers.addAll(marker);
  }

  void getLocation() async {
    Position position = await LocationService().getUserCurrentLocation();
    if (mounted) {
      // check if the widget is still in the widget tree
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

  /* void getLocation() async {
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
  }*/

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

class SafeLocation {
  final String name;
  final LatLng coordinates;

  SafeLocation(this.name, this.coordinates);
}

List<SafeLocation> safeLocations = [
  SafeLocation('Büyükçekmece Acil Toplanma Alanı', LatLng(41.0284, 28.5870)),
  SafeLocation('Adalar Acil Toplanma Alanı', LatLng(40.8490, 29.1233)),
  SafeLocation('Arnavutköy Acil Toplanma Alanı', LatLng(41.185915, 28.729731)),
  SafeLocation('Ataşehir Acil Toplanma Alanı', LatLng(40.9800, 29.0999)),
  SafeLocation('Beykoz Acil Toplanma Alanı', LatLng(41.145317, 29.086227)),
  SafeLocation('Beyoğlu Acil Toplanma Alanı', LatLng(41.0390, 28.9845)),
  SafeLocation('Çekmeköy Acil Toplanma Alanı', LatLng(41.0157, 29.1018)),
  SafeLocation('Esenler Acil Toplanma Alanı', LatLng(41.0141, 28.5354)),
  SafeLocation('Esenyurt Acil Toplanma Alanı', LatLng(41.0336, 28.4020)),
  SafeLocation('Eyüp Acil Toplanma Alanı', LatLng(41.089278, 28.923708)),
  SafeLocation('Fatih Acil Toplanma Alanı', LatLng(41.007324, 28.978153)),
  SafeLocation('Gaziosmanpaşa Acil Toplanma Alanı', LatLng(41.1145, 28.5920)),
  SafeLocation('Kadıköy Acil Toplanma Alanı', LatLng(40.5839, 29.0516)),
  SafeLocation('Kartal Acil Toplanma Alanı', LatLng(40.5416, 29.1028)),
  SafeLocation('Küçükçekmece Acil Toplanma Alanı', LatLng(40.5954, 28.4658)),
  SafeLocation('Maltepe Acil Toplanma Alanı', LatLng(40.939390, 29.131630)),
  SafeLocation('Pendik Acil Toplanma Alanı', LatLng(40.5224, 29.1908)),
  SafeLocation('Sarıyer Acil Toplanma Alanı', LatLng(41.106727, 29.017327)),
  SafeLocation('Silivri Acil Toplanma Alanı', LatLng(41.0354, 28.1659)),
  SafeLocation('Sultanbeyli Acil Toplanma Alanı', LatLng(40.5717, 29.1644)),
  SafeLocation('Sultangazi Acil Toplanma Alanı', LatLng(41.0641, 28.5217)),
  SafeLocation('Şile Acil Toplanma Alanı', LatLng(41.17755978, 29.62314785)),
  SafeLocation('Ümraniye Acil Toplanma Alanı', LatLng(41.030254, 29.105804)),
  SafeLocation('Üsküdar Acil Toplanma Alanı', LatLng(41.012825, 29.051967)),
  SafeLocation('Zeytinburnu Acil Toplanma Alanı', LatLng(41.0037, 28.5456)),
  SafeLocation('Bakırköy Acil Toplanma Alanı', LatLng(40.5726, 28.4957))
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
      mapController.animateCamera(
        CameraUpdate.newLatLng(selectedLocation.coordinates),
      );
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (selectedLocation != null) {
        close(context, selectedLocation);
      } else {
        close(context, SafeLocation('', const LatLng(0, 0)));
      }
    });
    return Container();
  }
}
