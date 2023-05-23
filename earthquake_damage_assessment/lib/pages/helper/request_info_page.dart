import 'package:earthquake_damage_assessment/pages/helper/helper_request_page.dart';
import 'package:flutter/material.dart';
import '../../service/helper_request.dart';

const statusTypes = <String>['received', 'on progress', 'completed'];
const rowNames = [
  "Emergency",
  "Request Time",
  "Location",
  "Directions",
  "Needs",
  "Victim Name",
  "Victim Phone Number",
  "Second Person To Be Reached",
  "Victim's Emergency Person Number"
];

class RequestInformationPage extends StatefulWidget {
  final HelperRequest helperRequest;

  const RequestInformationPage({required this.helperRequest});

  @override
  _RequestInformationPageState createState() => _RequestInformationPageState();
}

class _RequestInformationPageState extends State<RequestInformationPage> {
  late HelperRequest helperRequest;
  late String _requestStatusController;
  late List<String> rowValues;

  @override
  void initState() {
    super.initState();
    helperRequest = widget.helperRequest;
    _requestStatusController = helperRequest.status;
    rowValues = [
      helperRequest.emergency.toString(),
      helperRequest.time.toString(),
      "${helperRequest.location.latitude},  ${helperRequest.location.longitude}",
      helperRequest.directions,
      helperRequest.need,
      helperRequest.name,
      helperRequest.phone,
      helperRequest.secondPerson,
      helperRequest.emergencyPerson,
    ];
  }

  Widget statusBox() {
    return DropdownButton<String>(
      value: _requestStatusController,
      items: statusTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _requestStatusController = newValue!;
        });
      },
      focusColor: const Color.fromARGB(255, 226, 226, 226),
      autofocus: true,
      elevation: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = List.generate(9, (index) {
      String rowName = rowNames[index];
      String rowValue = rowValues[index];

      return DataRow(cells: [
        DataCell(Text(rowName)),
        DataCell(Text(rowValue)),
      ]);
    });

    return Scaffold(
      appBar: appBarButtons(context),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Center(
                  child: Text(
                    "Request Information Page",
                    style: TextStyle(
                      color: Color.fromRGBO(199, 0, 56, 0.89),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              titleText(helperRequest.type),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                  ],
                  rows: rows,
                ),
              ),
              SizedBox(height: 20),
              texts("Request Status"),
              SizedBox(height: 10),
              statusBox(),
              SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  updateRequestStatus(
                      helperRequest.requestID, _requestStatusController);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelperRequestPage(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(199, 0, 56, 0.89),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Update Status",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Text titleText(title) {
  return Text(
    title,
    style: const TextStyle(
      color: Color.fromRGBO(199, 0, 56, 0.89),
      fontSize: 22,
    ),
  );
}

Text texts(input) {
  return Text(
    input,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
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
