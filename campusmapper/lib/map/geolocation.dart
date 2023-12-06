import "package:latlong2/latlong.dart";
import 'package:geolocator/geolocator.dart';
import 'map_constants.dart';

class Geolocation {
  bool canFindLocation = false;

  Future<LatLng> getPosition() async {
    LatLng curLoc = MapConstants.mapCenter;
    if (!canFindLocation) {
      await checkLocationService();
    }
    if (canFindLocation) {
      Position pos = await Geolocator.getCurrentPosition();
      curLoc = LatLng(pos.latitude, pos.longitude);
    }
    print(curLoc);
    return curLoc;
  }

  Future<bool> checkLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      canFindLocation = false;
    } else {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          canFindLocation = false;
        } else {
          canFindLocation = true;
        }
      } else {
        canFindLocation = true;
      }
      if (permission == LocationPermission.deniedForever) {
        canFindLocation = false;
      } else {
        canFindLocation = true;
      }
    }
    return canFindLocation;
  }
}

class GeoLocation {
  Future<LatLng> getPosition() async {
    Position pos = await Geolocator.getCurrentPosition();
    LatLng curLoc = LatLng(pos.latitude, pos.longitude);
    return curLoc;
  }
}
