// Function to create a marker
import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker createMarker(
    double latitude, double longitude, int emergencyLevel, String userName) {
  // Determine the hue based on the emergency level
  double markerHue;
  switch (emergencyLevel) {
    case 1:
      markerHue = BitmapDescriptor.hueGreen;
      break;
    case 2:
      markerHue = BitmapDescriptor.hueYellow;
      break;
    case 3:
      markerHue = BitmapDescriptor.hueOrange;
      break;
    case 4:
      markerHue = BitmapDescriptor.hueRose;
      break;
    case 5:
      markerHue = BitmapDescriptor.hueRed;
      break;
    default:
      markerHue = BitmapDescriptor.hueBlue;
  }

  // Create a marker
  var marker = Marker(
    markerId: MarkerId('marker_${latitude}_${longitude}'),
    position: LatLng(latitude, longitude),
    icon: BitmapDescriptor.defaultMarkerWithHue(markerHue),
    infoWindow: InfoWindow(
      title: userName,
    ),
  );

  return marker;
}
