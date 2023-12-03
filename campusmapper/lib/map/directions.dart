import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'marker_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Directions {
  LatLng initialPosition;
  LatLng locationPosition;
  MarkerModel database;
  Directions(
      {required this.initialPosition,
      required this.locationPosition,
      required this.database});

  Future<List<LatLng>> getDirections() async {
    List<LatLng> result = [];
    result.add(initialPosition);
    final response = await http.get(Uri.parse(
        "https://api.openrouteservice.org/v2/directions/foot-walking?api_key=5b3ce3597851110001cf6248971ac7cbb13f4f56a282ce1cb4d02f80&start=${initialPosition.longitude.toString()},${initialPosition.latitude.toString()}&end=${locationPosition.longitude.toString()},${locationPosition.latitude.toString()}"));
    if (response.statusCode == 200) {
      final parsedData = json.decode(response.body);
      for (var i in parsedData["features"][0]["geometry"]["coordinates"]) {
        result.add(LatLng(i[1], i[0]));
      }
    }
    result.add(locationPosition);
    print(result);
    return result;
  }

  void setInitPos(LatLng initPos) {
    initialPosition = initPos;
  }

  void setItemPos(LatLng itemPos) {
    locationPosition = itemPos;
  }
}
