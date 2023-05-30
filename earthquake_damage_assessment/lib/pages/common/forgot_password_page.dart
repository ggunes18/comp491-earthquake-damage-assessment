import 'package:earthquake_damage_assessment/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:earthquake_damage_assessment/pages/common/login_page.dart';

final TextEditingController _mailController = TextEditingController();

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});
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
              forgotText(),
              const SizedBox(height: 10),
              texts("Email"),
              textFields("Please enter your email to reset your password",
                  _mailController),
              const SizedBox(height: 10),
              const SizedBox(height: 25),
              resetButton(context),
            ],
          ),
        ),
      ),
    );
  }
}

Text forgotText() {
  return const Text(
    'Forgot Password',
    style: TextStyle(
      color: Color.fromRGBO(199, 0, 56, 0.89),
      fontSize: 25,
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

TextButton resetButton(context) {
  return TextButton(
    onPressed: () {
      forgotPassword(context);
    },
    child: Container(
      height: 50,
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromRGBO(199, 0, 56, 0.89)),
      child: const Center(
        child: Text("Reset My Password",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
    ),
  );
}

void showInvalidDialog(
    BuildContext context, String title, String errorText) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
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

AppBar appBarButtons(context) {
  return AppBar(
    leading: const BackButton(
      color: Colors.black,
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

Future<void> forgotPassword(context) async {
  var status = await AuthService().resetPassword(email: _mailController.text);
  if (status == "success") {
    _mailController.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    showInvalidDialog(context, "Success", "Please check your e-mail!");
  } else {
    showInvalidDialog(context, "Error", status);
  }
}
