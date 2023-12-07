/* 
Author: Samiur Rahman - 100824221
The main application entry point, CampusNavigatorApp, defines a HomePage with a grid of NavigationCard 
widgets representing different sections of the app. The app includes features such as information center, 
campus food, accessibility directory, user schedule, and a campus map. Firebase is initialized for potential 
backend integration. Additionally, a login functionality is implemented, with the UI dynamically adjusting 
based on the user's login status.

Author: Darshilkumar Patel
Added helpbutton on homepage. Designed Navigationcards widgets to user friendly.

Author: Brock Davidge
Added functionality to connect to course search and weekly schedule.
*/
import 'package:campusmapper/scheduler/events_page.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_core/firebase_core.dart';
import 'package:campusmapper/map/firebase_options.dart';
import 'package:latlong2/latlong.dart';
import 'helpbutton.dart';
import 'courses/course_search_page.dart';
import 'courses/schedule_page.dart';
import 'courses/schedule_provider.dart';
import 'information_centre_page.dart';
import 'accessibility.dart';
import 'food.dart';
import 'scheduler/scheduler_handler.dart';
import 'student_login.dart';
import 'package:provider/provider.dart';
import 'package:campusmapper/map/map_maker.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(CampusNavigatorApp());
}

class CampusNavigatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Navigator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> navigationCards = [
      NavigationCard(
        icon: Icons.info,
        title: 'Information Center',
        color: Color(0xFF3498DB),
        onTap: () {
          // Add your navigation logic here
        },
      ),
      NavigationCard(
        icon: Icons.fastfood_sharp,
        title: 'Campus Food',
        color: Color(0xFF2ECC71),
        onTap: () {
          // Add your navigation logic here
        },
      ),
      NavigationCard(
        icon: Icons.accessible,
        title: 'Accessibility',
        color: Color(0xFFE67E22),
        onTap: () {
          // Add your navigation logic here
        },
      ),
      NavigationCard(
        icon: Icons.calendar_month,
        title: 'My Schedule',
        color: Color(0xFF9B59B6),
        onTap: () {
          // Add your navigation logic here
        },
      ),
      NavigationCard(
        icon: Icons.calendar_today,
        title: 'Weekly Schedule',
        color: Color(0xFF9B59B6),
        onTap: () {
          // Add your navigation logic here
        },
      ),
      NavigationCard(
        icon: Icons.map,
        title: 'Campus Map',
        color: Color(0xFF008080),
        onTap: () {
          // Add your navigation logic here
        },
      ),
      NavigationCard(
        icon: Icons.search,
        title: 'Search Courses',
        color: Color(0xFFFFD700),
        onTap: () {
          // Add your navigation logic here
        },
      ),
      Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 8.0),
        child: HelpButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Help'),
                  content: Text('This is the help message.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.greenAccent, // Set the background color here
      body: Column(
        children: [
          // Optional: Notification bar at the top
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.red, // Example color for the notification bar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Positions are now open!'),
                TextButton(
                  onPressed: () {},
                  child: Text('MORE'),
                ),
              ],
            ),
          ),
          // Adjusted GridView to match two-column layout
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Changed to 2 columns
              padding: EdgeInsets.all(8.0),
              childAspectRatio: 1.0, // Adjust the ratio to match the design
              children: navigationCards,
            ),
          ),
          // Optional: Bottom navigation bar
          // ...
        ],
      ),
    );
  }
}

class NavigationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const NavigationCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48.0),
            SizedBox(height: 16.0),
            Text(title, style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}

class HelpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HelpButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Help'),
    );
  }
}
