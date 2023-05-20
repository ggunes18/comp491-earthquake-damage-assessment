import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/phone_field.dart';
import 'victim_profile_page.dart';
import 'package:earthquake_damage_assessment/pages/victim/victim_edit.dart';

final TextEditingController _nameController = TextEditingController();
final TextEditingController _locationController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
String _bloodTypeController = 'A+';
final TextEditingController _emergencyPersonController =
    TextEditingController();

const bloodTypes = <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-'];

class VictimEditingPage extends StatefulWidget {
  const VictimEditingPage({Key? key}) : super(key: key);

  @override
  _VictimEditingPageState createState() => _VictimEditingPageState();
}

class _VictimEditingPageState extends State<VictimEditingPage> {
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
              phoneField("5xx-xxx-xxxx", _phoneController),
              const SizedBox(height: 10),
              texts("Blood Type"),
              bloodTypeBox(),
              const SizedBox(height: 10),
              texts("Emergency Person Number"),
              phoneField("5xx-xxx-xxxx", _emergencyPersonController),
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
              MaterialPageRoute(builder: (context) => VictimProfilePage()),
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

Padding phoneField(hintText, controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      autocorrect: false,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        PhoneInputFormatter(),
      ],
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: const Color.fromARGB(255, 226, 226, 226),
        filled: true,
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a phone number';
        }
        return null;
      },
    ),
  );
}

void showInvalidFieldsDialog(BuildContext context, String errorText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Missing information!"),
        content: Text(errorText),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Future<bool> saveCredentials(
    context,
    TextEditingController nameController,
    TextEditingController locationController,
    TextEditingController phoneController,
    String bloodTypeController,
    TextEditingController emergencyPersonController) async {
  if (nameController.text != "" &&
      locationController.text != "" &&
      phoneController.text != "" &&
      emergencyPersonController.text != "") {
    await VictimSaveService().save(
        nameSurname: _nameController.text,
        location: _locationController.text,
        phone: _phoneController.text,
        bloodType: _bloodTypeController,
        emergencyPerson: _emergencyPersonController.text);
    return false;
  } else {
    return true;
  }
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
    onPressed: () async {
      bool ifError = await saveCredentials(
          context,
          nameController,
          locationController,
          phoneController,
          bloodTypeController,
          emergencyPersonController);
      if (ifError == true) {
        showInvalidFieldsDialog(
            context, "Please make sure you provided every information!");
      } else {
        clearTextFields();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VictimProfilePage()),
        );
      }
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
