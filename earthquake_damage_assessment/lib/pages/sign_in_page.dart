import 'package:earthquake_damage_assessment/pages/first_page.dart';
import 'package:flutter/material.dart';
import 'package:earthquake_damage_assessment/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              signUpText(),
              const SizedBox(height: 10),
              texts("Email"),
              _entryField("Please enter your email", _mailController),
              const SizedBox(height: 10),
              texts("Username"),
              _entryField("Please enter your username", _userNameController),
              const SizedBox(height: 10),
              texts("Password"),
              _entryField("Please enter your password", _passwordController),
              const SizedBox(height: 10),
              victimHelperCheckBox(),
              const SizedBox(height: 25),
              signInButton(context),
              const SizedBox(height: 50),
              alreadyAMember(context),
            ],
          ),
        ),
      ),
    );
  }
}

final TextEditingController _mailController = TextEditingController();
final TextEditingController _userNameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

Widget _entryField(String title, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: title),
  );
}

Future<void> signUserIn(context) async {
  await AuthService().signIn(
      mail: _mailController.text,
      userName: _userNameController.text,
      password: _passwordController.text);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}

Text signUpText() {
  return const Text(
    'SIGN IN',
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

Padding victimHelperCheckBox() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Checkbox(value: false, onChanged: null),
        Text("Victim", style: TextStyle(fontSize: 11)),
        SizedBox(width: 10),
        Checkbox(value: false, onChanged: null),
        Text("Helper", style: TextStyle(fontSize: 11)),
      ],
    ),
  );
}

TextButton signInButton(context) {
  return TextButton(
    onPressed: () {
      signUserIn(context);
    },
    child: Container(
      height: 50,
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color.fromRGBO(199, 0, 56, 0.89)),
      child: const Center(
        child: Text("Sign In",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
    ),
  );
}

Row alreadyAMember(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Already a member?',
        style:
            TextStyle(color: Color.fromARGB(255, 103, 103, 103), fontSize: 13),
      ),
      const SizedBox(width: 4),
      TextButton(
        child: const Text(
          'Login now.',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    ],
  );
}
