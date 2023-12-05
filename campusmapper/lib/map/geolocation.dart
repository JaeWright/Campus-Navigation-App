import "package:latlong2/latlong.dart";
import 'package:geolocator/geolocator.dart';

class GeoLocation {
  Future<LatLng> getPosition() async {
    Position pos = await Geolocator.getCurrentPosition();
    LatLng curLoc = LatLng(pos.latitude, pos.longitude);
    print(curLoc);
    return curLoc;
  }
}
