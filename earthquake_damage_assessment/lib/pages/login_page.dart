import 'package:earthquake_damage_assessment/pages/home_page.dart';
import 'package:earthquake_damage_assessment/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              loginText(),
              const SizedBox(height: 10),
              _entryField(
                  "Please enter your email or username", _mailController),
              texts("Email or Username"),
              const SizedBox(height: 10),
              texts("Password"),
              const SizedBox(height: 10),
              _entryField("Please enter your password", _passwordController),
              const SizedBox(height: 10),
              remeberMeCheck(),
              forgotPassword(),
              const SizedBox(height: 25),
              loginButton(context),
              const SizedBox(height: 50),
              notAMember(context),
            ],
          ),
        ),
      ),
    );
  }
}

final TextEditingController _mailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

Future<void> login(context) async {
  await AuthService()
      .logIn(mail: _mailController.text, password: _passwordController.text);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomePage()),
  );
}

Widget _entryField(String title, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: title),
  );
}

Text loginText() {
  return const Text(
    'LOGIN',
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

Padding remeberMeCheck() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Checkbox(value: false, onChanged: null),
        Text("Remember me", style: TextStyle(fontSize: 11)),
      ],
    ),
  );
}

Padding forgotPassword() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    ),
  );
}

TextButton loginButton(context) {
  return TextButton(
    onPressed: () {
      login(context);
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

Row notAMember(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Not a member?',
        style:
            TextStyle(color: Color.fromARGB(255, 103, 103, 103), fontSize: 13),
      ),
      const SizedBox(width: 4),
      TextButton(
        child: const Text(
          'Register now',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        },
      ),
    ],
  );
}

void login(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomePage()),
  );
}
