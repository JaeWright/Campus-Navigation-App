import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? id;
  final LatLng? location;
  final List<String> additionalInfo;

  MapMarker(
      {required this.id, required this.location, required this.additionalInfo});
}
