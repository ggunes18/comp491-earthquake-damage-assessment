import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earthquake_damage_assessment/service/location_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'victim_home_page.dart';

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
              const SizedBox(height: 50),
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
      Get.defaultDialog(
          title: "Are your sure about request information?",
          middleText:
              "Your name: ${_nameController.text}\n Your location: ${globalLatitude.toString()}, ${globalLongitude.toString()}\n Your needs: ${_needsController.text}\n Extra information: ${_infoController.text}\n Emergency level: $emergencyLevel\n",
          textConfirm: "Yes",
          textCancel: "Edit request",
          onConfirm: () {
            addRequest(context, requestType);
          });
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
  await FirebaseFirestore.instance.collection("RequestTest").add({
    "type": requestType,
    "name": _nameController.text,
    "location": "${globalLatitude.toString()}, ${globalLongitude.toString()}",
    "directions": _directionsController,
    "need": _needsController.text,
    "info": _infoController.text,
    "secondPerson": _secondPersonController,
    "emergency": emergencyLevel
  });
  Get.defaultDialog(
    title: "Your request is saved.",
    content: Container(),
    textConfirm: "OK",
    onConfirm: () {
      _nameController.text = "";
      _needsController.text = "";
      _infoController.text = "";
      emergencyLevel = 0;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VictimHomePage()),
      );
    },
  );
}
