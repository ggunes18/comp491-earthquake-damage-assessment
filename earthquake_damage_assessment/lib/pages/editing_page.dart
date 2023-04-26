import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'package:earthquake_damage_assessment/pages/first_page.dart';
import 'package:flutter/material.dart';
import 'package:earthquake_damage_assessment/service/edituser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'home_page.dart';

class EditingPage extends StatelessWidget {
  EditingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              editText(),
              const SizedBox(height: 10),
              texts("Name and Surname"),
              _entryField(
                  "Please enter your name and surname", _nameController),
              const SizedBox(height: 10),
              texts("Location"),
              _entryField("Please enter your location", _locationController),
              const SizedBox(height: 10),
              texts("Biography"),
              _entryField("Please enter your biography", _biographyController),
              const SizedBox(height: 25),
              submitButton(context, _nameController, _locationController,
                  _biographyController),
            ],
          ),
        ),
      ),
    );
  }
}

final TextEditingController _nameController = TextEditingController();
final TextEditingController _locationController = TextEditingController();
final TextEditingController _biographyController = TextEditingController();

Widget _entryField(String title, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: title),
  );
}

Text editText() {
  return const Text(
    'Enter your new information',
    style: TextStyle(
      color: Color.fromRGBO(199, 0, 56, 0.89),
      fontSize: 20,
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

Future<void> savecredentials(
  context,
  TextEditingController nameController,
  TextEditingController locationController,
  TextEditingController biographyController,
) async {
  //NEW CODE
  await SaveService().save(
      namesurname: _nameController.text,
      location: _locationController.text,
      biography: _biographyController.text);
}

TextButton submitButton(
    context,
    TextEditingController nameController,
    TextEditingController locationController,
    TextEditingController biographyController) {
  return TextButton(
    onPressed: () {
      savecredentials(
        context,
        nameController,
        locationController,
        biographyController,
      ); //NEW CODE
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
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
        child: Text("Login",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
    ),
  );
}
