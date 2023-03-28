import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import 'login_page.dart';

class FirstPage extends StatelessWidget {
  FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              kuHelpText(),
              const SizedBox(height: 10),
              explanationText(),
              const SizedBox(height: 50),
              signInButton(context),
              const SizedBox(height: 50),
              alreadyAUser(context),
            ],
          ),
        ),
      ),
    );
  }
}

Padding kuHelpText() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Text(
          'KuHelp',
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
          ),
        ),
      ],
    ),
  );
}

Padding explanationText() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Text(
          'Explanation...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

TextButton signInButton(context) {
  return TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    },
    child: Container(
      height: 60,
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xffB45151)),
      child: const Center(
        child: Text("Sign In",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 20)),
      ),
    ),
  );
}

Row alreadyAUser(context) {
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
          'LOGIN',
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
