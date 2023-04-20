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
  final PageController pageController = PageController();
  final pages = [HomePage(), ProfilePage()];

  int currentIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.jumpToPage(index);
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) => ,)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator.getLastKnownPosition();
    var lat = position.latitude;
    var long = position.longitude;

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        /* body: PageView(
          controller: pageController,
          children: pages,
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ), */
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
          currentIndex: currentIndex,
          onTap: onItemTapped,
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

                  Container(
                    height: 450,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(0, 0),
                        zoom: 10,
                      ),
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
