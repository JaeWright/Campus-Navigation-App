/*
Author: Luca Lotito
Class that holds constant values used by the map marker 
Will likely be changed to be a YAML file for the final relase
*/
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
class MapConstants {
  static const String mapBoxStyleId = 'clomgqnky006x01qo1d507vrk';
  static const String mapBoxAccessToken =
      'pk.eyJ1IjoibHVjLWxvdCIsImEiOiJjbG9tNHpzdnkwam92MnFuMzgwNm5mNDRzIn0.45jDosysBYOtEdWZj39kTg';
  static const List<String> categories = [
    "Washroom",
    "Elevator",
    "Food",
    "Bus",
    "Bookstore",
    "Health",
    "Bike_Parking",
    "Emergency_Phone"
  ];
  static Widget circle = Container(
    width: 10,
    height: 10,
    decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
  );
  static LatLng mapUpperCorner = const LatLng(43.952142, -78.889625);
  static LatLng mapLowerCorner = const LatLng(43.940242, -78.902931);
  static LatLng mapCenter = const LatLng(43.9450787, -78.896847);
}
