import 'package:flutter/material.dart';
import 'admin_profile_page.dart';
import 'package:earthquake_damage_assessment/pages/helper/edit_helper.dart';

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
              textFields("Please enter your phone number", _phoneController),
              const SizedBox(height: 10),
              texts("Mail"),
              textFields("Please enter your mail", _mailController),
              const SizedBox(height: 10),
              submitButton(
                  context, _nameController, _phoneController, _mailController),
            ],
          ),
        ),
      ),
    );
  }
}

final TextEditingController _nameController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController _mailController = TextEditingController();

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
    leading: const BackButton(
      color: Colors.black,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
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
  await SaveService().save(
      namesurname: _nameController.text,
      phone: _phoneController.text,
      mail: _mailController.text);
}

TextButton submitButton(
    context,
    TextEditingController nameController,
    TextEditingController phoneController,
    TextEditingController mailController) {
  return TextButton(
    onPressed: () {
      savecredentials(
        context,
        nameController,
        phoneController,
        mailController,
      );
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
