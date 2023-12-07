import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: PhotoView(
                imageProvider: AssetImage(imagePath),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                initialScale: PhotoViewComputedScale.contained,
                enableRotation: false,
                backgroundDecoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static String? getMenuImagePath(String restaurantName) {
    return 'assets/menu_images/${restaurantName.toLowerCase().replaceAll(" ", "")}.jpg';
  }

  // simulate fetching menu data (returns image path as data)
  static Future<String?> fetchMenu(String restaurantName) async {
    // use a delay to simulate fetching data from a remote server or local storage
    await Future.delayed(Duration(seconds: 2));

    return getMenuImagePath(restaurantName);
  }
}