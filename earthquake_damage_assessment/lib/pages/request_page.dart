import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'home_page.dart';

class RequestPage extends StatelessWidget {
  final String request_type;

  RequestPage({super.key, required this.request_type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
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
              requestText(request_type),
              const SizedBox(height: 10),
              texts("Your Name"),
              textFields("Enter your name."),
              const SizedBox(height: 10),
              texts("Location"),
              textFields("Enter the location to send help."),
              const SizedBox(height: 10),
              texts("Needs"),
              textFields("If you need anything write it here."),
              const SizedBox(height: 10),
              texts("Extra Information"),
              textFields("Enter extra informtion if it is needed"),
              const SizedBox(
                height: 15,
              ),
              texts("Emergency Level"),
              retingBar(),
              const SizedBox(height: 20),
              submitButton(context),
            ],
          ),
        ),
      ),
    );
  }
}

Text requestText(request_text) {
  return Text(
    request_text,
    style: TextStyle(
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

Padding textFields(hintText) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: TextField(
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

RatingBar retingBar() {
  return RatingBar(
    initialRating: 0,
    direction: Axis.horizontal,
    allowHalfRating: false,
    itemCount: 5,
    ratingWidget: RatingWidget(
      full: Icon(
        Icons.circle_rounded,
        color: Color.fromRGBO(199, 0, 56, 0.89),
      ),
      half: Icon(Icons.circle_rounded),
      empty: Icon(Icons.circle_outlined),
    ),
    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
    onRatingUpdate: (rating) {
      print(rating);
    },
  );
}

TextButton submitButton(context) {
  return TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    },
    child: Container(
      height: 50,
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color.fromRGBO(199, 0, 56, 0.89)),
      child: const Center(
        child: Text("Submit",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
    ),
  );
}
