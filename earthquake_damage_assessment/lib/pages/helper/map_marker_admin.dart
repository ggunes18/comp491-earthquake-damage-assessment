import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker createMarker(double latitude, double longitude, int emergencyLevel,
    String userName, String status) {
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
    markerId: MarkerId('${latitude}_${longitude}'),
    position: LatLng(latitude, longitude),
    icon: BitmapDescriptor.defaultMarkerWithHue(markerHue),
    infoWindow: InfoWindow(
        title: 'marker_${userName}',
        snippet: 'Status: ${status}, Emergency Level: ${emergencyLevel}'),
  );

  return marker;
}
