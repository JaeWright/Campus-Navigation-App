/*Luca Lotito
Handler for the MapMarker, holds the data values for one
*/
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {
  final String id;
  final LatLng location;
  final Icon icon;
  final String additionalInfo;

  MapMarker(
      {required this.id,
      required this.location,
      required this.icon,
      required this.additionalInfo});
}
