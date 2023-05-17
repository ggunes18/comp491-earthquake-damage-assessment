import 'package:flutter/material.dart';

bool isVictim = true;
bool isHelper = false;

class VictimHelperCheckBoxes extends StatefulWidget {
  @override
  _VictimHelperCheckBoxesState createState() => _VictimHelperCheckBoxesState();

  get isVictimSelected => isVictim;
  get isHelperSelected => isHelper;
}

class _VictimHelperCheckBoxesState extends State<VictimHelperCheckBoxes> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: isVictim,
            activeColor: const Color.fromRGBO(199, 0, 56, 0.89),
            onChanged: (value) {
              setState(() {
                isVictim = value!;
                isHelper = !value;
              });
            },
          ),
          const Text("Victim", style: TextStyle(fontSize: 11)),
          const SizedBox(width: 10),
          Checkbox(
            value: isHelper,
            activeColor: const Color.fromRGBO(199, 0, 56, 0.89),
            onChanged: (value) {
              setState(() {
                isHelper = value!;
                isVictim = !value;
              });
            },
          ),
          const Text("Helper", style: TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
