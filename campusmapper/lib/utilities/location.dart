/*
Author: Darshilkumar Patel
Facilitates handling restaurant locations, navigating to them on a map,
and managing the map screen.
*/

import 'package:campusmapper/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class RestaurantLocation {
  final String name;
  final double latitude;
  final double longitude;

  RestaurantLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class LocationService {
  final List<RestaurantLocation> hardcodedRestaurantLocations = [
    RestaurantLocation(
        name: 'Cafe', latitude: 43.9449322, longitude: -78.8935989),
    RestaurantLocation(
        name: 'Booster Juice', latitude: 43.9441469, longitude: -78.8949048),
    RestaurantLocation(
        name: 'Drip Cafe', latitude: 43.9441574, longitude: -78.8959321),
    RestaurantLocation(
        name: 'Tim Hortons', latitude: 43.9453491, longitude: -78.8976195),
    RestaurantLocation(
        name: 'Hunter Kitchen', latitude: 43.9455932, longitude: -78.896558),
    // Add other restaurant locations here
  ];

  void navigateToRestaurantLocation(
      BuildContext context, RestaurantLocation restaurantLocation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListMapScreen(
          findLocation:
              LatLng(restaurantLocation.latitude, restaurantLocation.longitude),
          type: "Food",
          // Pass the list of restaurant locations to the map screen
        ),
      ),
    );
  }

  // Example method to get all restaurant locations
  List<RestaurantLocation> getAllRestaurantLocations() {
    return hardcodedRestaurantLocations;
  }
}
