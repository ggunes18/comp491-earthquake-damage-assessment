import 'package:earthquake_damage_assessment/pages/home_page_buttons.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';

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
  
  @override
  Widget build(BuildContext context) {
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
          selectedItemColor: Color.fromRGBO(199, 0, 56, 0.89),
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 7),
                        Text(
                          "Search Safe Location",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Map Integration
                  //TO DO
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
