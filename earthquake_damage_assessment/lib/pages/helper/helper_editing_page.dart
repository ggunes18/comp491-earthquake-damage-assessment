import 'package:flutter/material.dart';
import '../common/phone_field.dart';
import 'helper_profile_page.dart';
import 'package:earthquake_damage_assessment/pages/helper/helper_edit.dart';
import 'package:flutter/services.dart';

final TextEditingController _nameController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();

class HelperEditingPage extends StatelessWidget {
  const HelperEditingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              MaterialPageRoute(
                  builder: (context) => const HelperProfilePage()),
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
        title: const Text('Missing Information!'),
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
  TextEditingController phoneController,
) async {
  if (nameController.text != "" && phoneController.text != "") {
    await HelperSaveService()
        .save(nameSurname: _nameController.text, phone: _phoneController.text);
    return false;
  } else {
    return true;
  }
}

TextButton submitButton(context, TextEditingController nameController,
    TextEditingController phoneController) {
  return TextButton(
    onPressed: () async {
      bool ifError =
          await saveCredentials(context, nameController, phoneController);
      if (ifError == true) {
        showInvalidFieldsDialog(
            context, "Please make sure you provided every information!");
      } else {
        _nameController.clear();
        _phoneController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelperProfilePage()),
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
