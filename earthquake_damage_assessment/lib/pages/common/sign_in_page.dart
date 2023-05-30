import 'package:flutter/material.dart';
import 'package:earthquake_damage_assessment/pages/common/checkbox_victim_helper.dart';
import 'package:earthquake_damage_assessment/pages/common/first_page.dart';
import 'package:earthquake_damage_assessment/service/auth.dart';
import 'package:earthquake_damage_assessment/pages/common/login_page.dart';

final TextEditingController _mailController = TextEditingController();
final TextEditingController _usernOrganizationController =
    TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _passwordControllerSecond = TextEditingController();

final VictimHelperCheckBoxes _checkBoxes = VictimHelperCheckBoxes();

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

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
              textFields("Please enter your email", _mailController),
              const SizedBox(height: 10),
              texts("Username (Organization for helpers)"),
              textFields(
                  "Please enter your username (organization for helpers)",
                  _usernOrganizationController),
              const SizedBox(height: 10),
              texts("Password"),
              textFields("Please enter your password", _passwordController),
              texts("Password"),
              textFields("Please enter your password again",
                  _passwordControllerSecond),
              const SizedBox(height: 10),
              _checkBoxes,
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
      obscureText: hintText == "Please enter your password" ||
              hintText == "Please enter your password again"
          ? true
          : false,
      enableSuggestions: hintText == "Please enter your password" ||
              hintText == "Please enter your password again"
          ? false
          : true,
      autocorrect: hintText == "Please enter your password" ||
              hintText == "Please enter your password again"
          ? false
          : true,
    ),
  );
}

TextButton signInButton(context) {
  return TextButton(
    onPressed: () {
      if (_checkBoxes.isHelperSelected) {
        signHelperIn(context);
      } else {
        signVictimIn(context);
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
          _mailController.clear();
          _usernOrganizationController.clear();
          _passwordController.clear();
          _passwordControllerSecond.clear();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ),
    ],
  );
}

void showInvalidSigninDialog(BuildContext context, String errorText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Invalid Signin'),
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

Future<void> signVictimIn(context) async {
  if (_passwordController.text == _passwordControllerSecond.text) {
    await AuthService()
        .signVictimIn(
            mail: _mailController.text,
            userName: _usernOrganizationController.text,
            password: _passwordController.text,
            isVictim: _checkBoxes.isVictimSelected,
            isHelper: _checkBoxes.isHelperSelected)
        .then((uid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      _mailController.clear();
      _usernOrganizationController.clear();
      _passwordController.clear();
    }).catchError((e) {
      showInvalidSigninDialog(context, e.message);
    });
  } else {
    showInvalidSigninDialog(context, "Please make sure your passwords match!");
  }
}

Future<void> signHelperIn(context) async {
  if (_passwordController.text == _passwordControllerSecond.text) {
    await AuthService()
        .signHelperIn(
            mail: _mailController.text,
            organization: _usernOrganizationController.text,
            password: _passwordController.text,
            isVictim: _checkBoxes.isVictimSelected,
            isHelper: _checkBoxes.isHelperSelected)
        .then((uid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      _mailController.clear();
      _usernOrganizationController.clear();
      _passwordController.clear();
    }).catchError((e) {
      showInvalidSigninDialog(context, e.message);
    });
  } else {
    showInvalidSigninDialog(context, "Please make sure your passwords match!");
  }
}
