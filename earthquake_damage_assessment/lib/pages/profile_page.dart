import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarButtons(),
      body: body(),
    );
  }
}

AppBar appBarButtons() {
  return AppBar(
    leading: BackButton(
      color: Colors.black,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.ios_share),
        color: Colors.black,
      )
    ],
  );
}

ListView body() {
  return ListView(
    physics: BouncingScrollPhysics(),
    children: [
      profilePhoto(),
      SizedBox(
        height: 20,
      ),
      nameText(),
      locationText(),
      SizedBox(
        height: 20,
      ),
      biography_text(),
      SizedBox(
        height: 20,
      ),
      iconButtons(),
      SizedBox(
        height: 20,
      ),
      Divider(
        color: Colors.black,
        height: 25,
        thickness: 1,
        indent: 25,
        endIndent: 25,
      ),
      SizedBox(
        height: 20,
      ),
      requests(),
    ],
  );
}

CircleAvatar profilePhoto() {
  return CircleAvatar(
    //backgroundImage: AssetImage("assets/images/profile_picture.png"),
    radius: 120,
  );
}

Center nameText() {
  return Center(
      child: Text(
    'Name Surname',
    style: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
  ));
}

Center locationText() {
  return Center(
      child: Text(
    'Location',
    style: TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
  ));
}

Padding biography_text() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Biography...",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

Row iconButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(onPressed: () {}, icon: Icon(Icons.local_phone)),
      IconButton(onPressed: () {}, icon: Icon(Icons.mail)),
    ],
  );
}

Container requests() {
  return Container(
    child: Column(children: [
      Text("Request 1 - (Request Type)"),
      Text("Adress"),
    ]),
  );
}
