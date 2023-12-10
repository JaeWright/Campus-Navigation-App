/*
Author: Luca Lotito
Class that holds constant values used by the map marker
*/
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapConstants {
  //Exposing some API keys. Nice
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
    "Emergency_Phone",
  ];
  //Circle widget for user locations
  static Widget circle = Container(
    width: 10,
    height: 10,
    decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
  );
  static LatLng mapUpperCorner = const LatLng(43.952142, -78.889625);
  static LatLng mapLowerCorner = const LatLng(43.940242, -78.902931);
  static LatLng mapCenter = const LatLng(43.9450787, -78.896847);
  //Helper function to get rid of underscores and table names that don't look good to read
  static String translateCategory(String category) {
    if (category == "Bike_Parking") {
      return "Bike Parking";
    } else if (category == "Emergency_Phone") {
      return "Emergency Phone";
    } else if (category == "Bus") {
      return "Public Transport";
    } else if (category == "Accessible") {
      return "Accessible Entrance";
    } else {
      return category;
    }
  }
}
