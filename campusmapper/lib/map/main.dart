/*
Author: Luca Lotito
Class used for testing the map in isolation from the rest of the project 
*/
import 'package:flutter/material.dart';
import '../food/location.dart';
import 'map_maker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:latlong2/latlong.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Create an instance of your LocationService
  LocationService locationService = LocationService();

  runApp(MaterialApp(
    title: 'Grade Viewer',
    home: ListMapScreen(
      findLocation: LatLng(0.0, 0.0),
      restaurantLocations: locationService.hardcodedRestaurantLocations, // Use your restaurant locations from LocationService
    ),
  ));
}
