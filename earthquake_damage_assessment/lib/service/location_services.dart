
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double globalLatitude = 0.0;
double globalLongitude = 0.0;

class LocationService {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  Future<Position> getUserCurrentLocation() async {
    bool serviceEnables;
    LocationPermission permission;

    serviceEnables = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnables) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    globalLatitude = position.latitude;
    globalLongitude = position.longitude;
    return position;
  }
}
