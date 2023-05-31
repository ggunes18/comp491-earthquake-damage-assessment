import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earthquake_damage_assessment/service/location_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'home_page_victim.dart';
import 'package:intl/intl.dart';

final TextEditingController _nameController = TextEditingController();
final TextEditingController _needsController = TextEditingController();
final TextEditingController _directionsController = TextEditingController();
final TextEditingController _secondPersonController = TextEditingController();
final TextEditingController _infoController = TextEditingController();
double emergencyLevel = 0;

class VictimRequestPage extends StatelessWidget {
  final String requestType;

  const VictimRequestPage({super.key, required this.requestType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VictimHomePage()),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              requestText(requestType),
              const SizedBox(height: 10),
              texts("Your Name"),
              textFields("Enter your name.", _nameController),
              const SizedBox(height: 10),
              texts("Needs"),
              textFields(
                  "If you need anything write it here.", _needsController),
              const SizedBox(height: 10),
              texts("Directions"),
              textFields("Enter the directions", _directionsController),
              const SizedBox(height: 10),
              texts("Second person to be reached"),
              textFields("Second person to be reached in an emergency",
                  _secondPersonController),
              const SizedBox(height: 10),
              texts("Extra Information"),
              textFields(
                  "Enter extra informtion if it is needed", _infoController),
              const SizedBox(
                height: 15,
              ),
              texts("Emergency Level"),
              ratingBar(),
              const SizedBox(height: 20),
              submitButton(context, requestType),
            ],
          ),
        ),
      ),
    );
  }
}

Text requestText(requestText) {
  return Text(
    requestText,
    style: const TextStyle(
      color: Color.fromRGBO(199, 0, 56, 0.89),
      fontSize: 30,
    ),
  );
}

Padding texts(text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

Padding textFields(hintText, controllerType) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: TextField(
      controller: controllerType,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: const Color.fromARGB(255, 226, 226, 226),
        filled: true,
        hintText: hintText,
      ),
    ),
  );
}

RatingBar ratingBar() {
  return RatingBar(
    initialRating: 0,
    direction: Axis.horizontal,
    allowHalfRating: false,
    itemCount: 5,
    ratingWidget: RatingWidget(
      full: const Icon(
        Icons.circle_rounded,
        color: Color.fromRGBO(199, 0, 56, 0.89),
      ),
      half: const Icon(Icons.circle_rounded),
      empty: const Icon(Icons.circle_outlined),
    ),
    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
    onRatingUpdate: (rating) {
      emergencyLevel = rating;
    },
  );
}

TextButton submitButton(context, requestType) {
  return TextButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Are your sure about request information?"),
            content: Text(
              "Your name: ${_nameController.text}\nYour location: ${globalLatitude.toString()}, ${globalLongitude.toString()}\nYour directions: ${_directionsController.text}\nYour needs: ${_needsController.text}\nSecond person to be reached: ${_secondPersonController.text}\nExtra information: ${_infoController.text}\nEmergency level: $emergencyLevel\n",
            ),
            actions: [
              TextButton(
                child: const Text('Edit Request'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  addRequest(context, requestType);
                },
              ),
            ],
          );
        },
      );
    },
    child: Container(
      height: 50,
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromRGBO(199, 0, 56, 0.89)),
      child: const Center(
        child: Text("Submit",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
    ),
  );
}

Future<void> addRequest(context, requestType) async {
  var firestore = FirebaseFirestore.instance;
  await firestore.collection("RequestTest").add({
    "type": requestType,
    "name": _nameController.text,
    "location": GeoPoint(globalLatitude, globalLongitude),
    "directions": _directionsController.text,
    "need": _needsController.text,
    "info": _infoController.text,
    "secondPerson": _secondPersonController.text,
    "emergency": emergencyLevel,
    "status": "received",
    "time": DateTime.fromMillisecondsSinceEpoch(DateTime.now()
            .toUtc()
            .add(const Duration(hours: 0))
            .millisecondsSinceEpoch ~/
        1000 *
        1000),
    "userID": firestore
        .collection('UserTest')
        .doc(FirebaseAuth.instance.currentUser?.uid)
  });
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Your request is saved!'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              requestType = "";
              _directionsController.text = "";
              _nameController.text = "";
              _needsController.text = "";
              _infoController.text = "";
              _secondPersonController.text = "";
              emergencyLevel = 0;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VictimHomePage()),
              );
            },
          )
        ],
      );
    },
  );
}
