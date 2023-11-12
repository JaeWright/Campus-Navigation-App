/* 
Author: Samiur Rahman - 100824221
A StatelessWidget representing a Food Page with a menu, showcasing items 
such as Pizza and Sushi. Data, including calories, price, and cuisine, is 
currently hardcoded for demonstration purposes.
*/
import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This data should ideally come from a backend or a local JSON file
    final foodMenu = [
      {
        'name': 'Pizza',
        'details': {'calories': '285', 'price': '9.99', 'cuisine': 'Italian'},
      },
      {
        'name': 'Sushi',
        'details': {'calories': '200', 'price': '12.99', 'cuisine': 'Japanese'},
      },
      // Add more food items
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Row(children: [
          Icon(Icons.fastfood_sharp),
          Padding(
              padding: EdgeInsetsDirectional.only(start: 10),
              child: Text("Food Menu"))
        ]),
      ),
      body: ListView.builder(
        itemCount: foodMenu.length,
        itemBuilder: (context, index) {
          var food = foodMenu[index];
          var foodDetails = food['details'] as Map<String, dynamic>?;
          return ExpansionTile(
            title: Text(food['name'] as String? ?? 'Unknown Food Item'),
            children: [
              ListTile(
                title: Text('Calories: ${foodDetails?['calories'] ?? 'N/A'}'),
              ),
              ListTile(
                title: Text('Price: \$${foodDetails?['price'] ?? 'N/A'}'),
              ),
              ListTile(
                title: Text('Cuisine: ${foodDetails?['cuisine'] ?? 'N/A'}'),
              ),
            ],
          );
        },
      ),
    );
  }
}
