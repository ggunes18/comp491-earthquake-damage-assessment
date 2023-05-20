import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earthquake_damage_assessment/pages/common/forgot_password_page.dart';
import 'package:earthquake_damage_assessment/pages/victim/home_page.dart';
import 'package:earthquake_damage_assessment/service/auth.dart';
import 'package:flutter/material.dart';
import '../helper/admin_home_page.dart';
import 'sign_in_page.dart';

final TextEditingController _mailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
              texts("Email"),
              textFields("Please enter your email", _mailController),
              const SizedBox(height: 10),
              texts("Password"),
              const SizedBox(height: 10),
              textFields("Please enter your password", _passwordController),
              const SizedBox(height: 10),
              forgotPassword(context),
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
      obscureText: hintText == "Please enter your password" ? true : false,
      enableSuggestions:
          hintText == "Please enter your password" ? false : true,
      autocorrect: hintText == "Please enter your password" ? false : true,
    ),
  );
}

Padding forgotPassword(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: const Text(
            'Forgot password?',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage()),
            );
          },
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
          color: const Color.fromRGBO(199, 0, 56, 0.89)),
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
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        },
      ),
    ],
  );
}

void showInvalidLoginDialog(BuildContext context, String errorText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Invalid Login'),
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

Future<void> login(context) async {
  await AuthService()
      .logIn(mail: _mailController.text, password: _passwordController.text)
      .then((uid) {
    FirebaseFirestore.instance
        .collection('UserTest')
        .doc(uid as String?)
        .get()
        .then((doc) {
      if (doc.exists) {
        bool isHelper = doc.get('isHelper');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  isHelper ? const AdminPage() : const HomePage()),
        );
        _mailController.clear();
        _passwordController.clear();
      }
    }).catchError((e) {
      showInvalidLoginDialog(context, e.message);
    });
  });
}
