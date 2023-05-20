import 'package:flutter/material.dart';
import '../common/phone_field.dart';
import 'admin_profile_page.dart';
import 'package:earthquake_damage_assessment/pages/helper/edit_helper.dart';
import 'package:flutter/services.dart';

final TextEditingController _nameController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();

class AdminEditingPage extends StatelessWidget {
  const AdminEditingPage({super.key});

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
              texts("Phone Number"),
              phoneField("5xx-xxx-xxxx", _phoneController),
              const SizedBox(height: 10),
              submitButton(context, _nameController, _phoneController),
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
            _nameController.clear();
            _phoneController.clear();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminProfilePage()),
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

Future<void> savecredentials(
  context,
  TextEditingController nameController,
  TextEditingController phoneController,
) async {
  await SaveService()
      .save(nameSurname: _nameController.text, phone: _phoneController.text);
}

TextButton submitButton(context, TextEditingController nameController,
    TextEditingController phoneController) {
  return TextButton(
    onPressed: () {
      savecredentials(context, nameController, phoneController);
      _nameController.clear();
      _phoneController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminProfilePage()),
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
