/*
Author: Luca Lotito
Handler for the MapMarker, holds the data values for one
*/
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {
  final String id;
  final String type;
  final LatLng location;
  final Icon icon;
  final String additionalInfo;

  MapMarker(
      {required this.id,
      required this.type,
      required this.location,
      required this.icon,
      required this.additionalInfo});
}

class Building {
  final LatLng accessibleEntrance;
  final String buildingName;
  final String owner;
  final String buildingUse;
  Building(
      {required this.accessibleEntrance,
      required this.buildingName,
      required this.owner,
      required this.buildingUse});
}
