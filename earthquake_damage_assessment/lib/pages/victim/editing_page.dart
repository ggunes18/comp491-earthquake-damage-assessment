import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'package:earthquake_damage_assessment/pages/victim/edit_victim.dart';

final TextEditingController _nameController = TextEditingController();
final TextEditingController _locationController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
String _bloodTypeController = 'A+';
final TextEditingController _emergencyPersonController =
    TextEditingController();

const bloodTypes = <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-'];

class EditingPage extends StatefulWidget {
  const EditingPage({Key? key}) : super(key: key);

  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  Widget bloodTypeBox() {
    return DropdownButton<String>(
      value: _bloodTypeController,
      items: bloodTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _bloodTypeController = newValue!;
        });
      },
      focusColor: Color.fromARGB(255, 226, 226, 226),
      autofocus: true,
      elevation: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarButtons(context),
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
              textFields(
                  "Please enter your location (city/county/neighborhood)",
                  _locationController),
              const SizedBox(height: 10),
              texts("Phone Number"),
              textFields("(5xx)xxxxxxx", _phoneController),
              const SizedBox(height: 10),
              texts("Blood Type"),
              bloodTypeBox(),
              const SizedBox(height: 10),
              texts("Emergency Person Number"),
              textFields("(5xx)xxxxxxx", _emergencyPersonController),
              const SizedBox(height: 10),
              submitButton(
                  context,
                  _nameController,
                  _locationController,
                  _phoneController,
                  _bloodTypeController,
                  _emergencyPersonController),
            ],
          ),
        ),
      ),
    );
  }
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

AppBar appBarButtons(context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Builder(
      builder: (BuildContext context) {
        return BackButton(
          onPressed: () {
            clearTextFields();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          color: Colors.black,
        );
      },
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
    TextEditingController phoneController,
    String bloodTypeController,
    TextEditingController emergencyPersonController) async {
  await SaveService().save(
      nameSurname: _nameController.text,
      location: _locationController.text,
      phone: _phoneController.text,
      bloodType: _bloodTypeController,
      emergencyPerson: _emergencyPersonController.text);
}

TextButton submitButton(
  context,
  TextEditingController nameController,
  TextEditingController locationController,
  TextEditingController phoneController,
  String bloodTypeController,
  TextEditingController emergencyPersonController,
) {
  return TextButton(
    onPressed: () {
      savecredentials(context, nameController, locationController,
          phoneController, bloodTypeController, emergencyPersonController);
      clearTextFields();
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
          color: const Color.fromRGBO(199, 0, 56, 0.89)),
      child: const Center(
        child: Text("Save",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
    ),
  );
}

void clearTextFields() {
  _nameController.clear();
  _locationController.clear();
  _phoneController.clear();
  _emergencyPersonController.clear();
}
