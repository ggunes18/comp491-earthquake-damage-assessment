import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import 'login_page.dart';

class FirstPage extends StatelessWidget {
  FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: height * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/kuhelp.png"),
                    //fit: BoxFit.cover,
                  ),
                ),
              ),
              //kuHelpText(),
              const SizedBox(height: 20),
              explanationText(),
              const SizedBox(height: 30),
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
      children: [
        Container(
          width: 360,
          child: Text(
            'Bridging the communication gap between earthquake victims and aid groups. ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
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
          color: Color.fromRGBO(199, 0, 56, 0.89)),
      child: const Center(
        child: Text("Sign In",
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1), fontSize: 20)),
      ),
    ),
  );
}

Column alreadyAUser(context) {
  return Column(
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
