import 'package:flutter/material.dart';

class MenuService {
  static Map<String, String> menuImagePaths = {
    'Cafe': 'assets/menu_images/cafe.jpg',
    'Booster Juice': 'assets/menu_images/boosterjuice.jpg',
    'Drip Cafe': 'assets/menu_images/dripcafe.jpg',
    'Tim Hortons': 'assets/menu_images/timhortons.jpg',
    'Hunter Kitchen': 'assets/menu_images/hunterkitchen.jpg',
    // Add other restaurant menu image paths here
  };

  static void showMenuImage(BuildContext context, String imagePath) {
    // Show the menu image using the passed imagePath
    // Implement your logic to display the menu image in a dialog or widget
    // For example, you can use a simple dialog box to display the image:
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Image.asset(imagePath), // Displaying the image in a dialog
      ),
    );
  }

  static String? getMenuImagePath(String restaurantName) {
    return 'assets/menu_images/${restaurantName.toLowerCase().replaceAll(" ", "")}.jpg';
    // Assuming the image names match the restaurant names in lowercase without spaces
  }

  // Simulate fetching menu data (returns image path as data)
  static Future<String?> fetchMenu(String restaurantName) async {
    // Use a delay to simulate fetching data from a remote server or local storage
    await Future.delayed(Duration(seconds: 2));

    return getMenuImagePath(restaurantName);
  }
}