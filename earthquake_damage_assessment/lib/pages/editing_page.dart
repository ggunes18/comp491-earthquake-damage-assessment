import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'package:earthquake_damage_assessment/service/edituser.dart';

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
              textFields("Please enter your name and surname", _nameController),
              const SizedBox(height: 10),
              texts("Location"),
              textFields("Please enter your location", _locationController),
              const SizedBox(height: 10),
              texts("Biography"),
              textFields("Please enter your biography", _biographyController),
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
        child: Text("Save",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
    ),
  );
}
