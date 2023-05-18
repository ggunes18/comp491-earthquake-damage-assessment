import 'package:flutter/material.dart';
import 'request_page.dart';

class HomePageButton extends StatelessWidget {
  final String text;
  const HomePageButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RequestPage(
                    requestType: text,
                  )),
        );
      },
      style: TextButton.styleFrom(
          backgroundColor: const Color.fromRGBO(199, 0, 56, 0.89),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ) // Background Color
          ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
