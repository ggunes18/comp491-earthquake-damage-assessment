import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker createMarker(double latitude, double longitude, String emergencyLevel,
    String userName, String status) {
  double markerHue;
  if (emergencyLevel == "1") {
    markerHue = BitmapDescriptor.hueGreen;
  } else if (emergencyLevel == "2") {
    markerHue = BitmapDescriptor.hueYellow;
  } else if (emergencyLevel == "3") {
    markerHue = BitmapDescriptor.hueOrange;
  } else if (emergencyLevel == "4") {
    markerHue = BitmapDescriptor.hueRose;
  } else if (emergencyLevel == "5") {
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
        title: 'marker_${userName}',
        snippet: 'Status: ${status}, Emergency Level: ${emergencyLevel}'),
  );

  return marker;
}
