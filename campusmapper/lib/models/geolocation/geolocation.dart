//Author: Luca Lotito
//This class deals with locating the user, as well as requesting user permission
import "package:latlong2/latlong.dart";
import 'package:geolocator/geolocator.dart';
import '../constants/map_constants.dart';

class Geolocation {
  bool canFindLocation = false;

  Future<LatLng> getPosition() async {
    //Default location
    LatLng curLoc = MapConstants.mapCenter;
    if (canFindLocation) {
      Position pos = await Geolocator.getCurrentPosition();
      curLoc = LatLng(pos.latitude, pos.longitude);
    }
    return curLoc;
  }

  //Checker to see if location services are enabled
  //Triggers upon reopening the map for the second time if not allowed,
  //as the deniedForever permission appears to be bugged and only properly updates after
  //being denied twice
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
      }
    }
    return canFindLocation;
  }
}
