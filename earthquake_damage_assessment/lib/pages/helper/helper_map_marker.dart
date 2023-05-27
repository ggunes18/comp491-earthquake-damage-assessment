import 'package:earthquake_damage_assessment/pages/helper/request_info_page.dart';
import 'package:earthquake_damage_assessment/service/helper_request.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker createMarker(BuildContext context, double latitude, double longitude,
    int emergencyLevel, String userName, String status, HelperRequest request) {
  double markerHue;
  if (emergencyLevel == 1) {
    markerHue = BitmapDescriptor.hueGreen;
  } else if (emergencyLevel == 2) {
    markerHue = BitmapDescriptor.hueYellow;
  } else if (emergencyLevel == 3) {
    markerHue = BitmapDescriptor.hueOrange;
  } else if (emergencyLevel == 4) {
    markerHue = BitmapDescriptor.hueRose;
  } else if (emergencyLevel == 5) {
    markerHue = BitmapDescriptor.hueRed;
  } else {
    markerHue = BitmapDescriptor.hueBlue;
  }

  // Create a marker
  var marker = Marker(
    markerId: MarkerId('${latitude}_${longitude}'),
    position: LatLng(latitude, longitude),
    icon: BitmapDescriptor.defaultMarkerWithHue(markerHue),
    infoWindow: InfoWindow(
      title: userName,
      snippet: 'Status: ${status}, Emergency Level: ${emergencyLevel}',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RequestInformationPage(helperRequest: request),
          ),
        );
      },
    ),
  );

  return marker;
}
