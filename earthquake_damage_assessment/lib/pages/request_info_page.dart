import 'package:flutter/material.dart';

class RequestInformationPage extends StatelessWidget {
  RequestInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarButtons(context),
        body: SafeArea(
            child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: [
                  Text(
                    "Request Information Page",
                    style: TextStyle(
                      color: Color.fromRGBO(199, 0, 56, 0.89),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50),
            titleText("Title"),
            const SizedBox(height: 20),
            texts("Urgency: 5/5"),
            const SizedBox(height: 20),
            texts("Location"),
            const SizedBox(height: 20),
            texts("Needs"),
            const SizedBox(height: 20),
            texts("Username"),
            const SizedBox(height: 20),
            texts("Phone Number"),
            const SizedBox(height: 20),
            texts("Mail"),
            const SizedBox(height: 20),
            texts("Emergency Phone Number"),
            const SizedBox(height: 20),
          ]),
        )));
  }
}

Text titleText(title) {
  return Text(
    title,
    style: TextStyle(
      color: Color.fromRGBO(199, 0, 56, 0.89),
      fontSize: 20,
    ),
  );
}

Text texts(input) {
  return Text(
    input,
    style: TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
  );
}

AppBar appBarButtons(context) {
  return AppBar(
    leading: BackButton(
      color: Colors.black,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
