/*
Author: Darshilkumar Patel - 100832600
This page manages the HelpButton shown on home page and when clicked on it there are detailed
guidelines for how to access each app functionality for user's assistance.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'restaurant_details.dart';
import 'information_centre_page.dart';
import 'accessibility.dart';
import 'map_screen.dart';
import 'scheduler_handler.dart';
import 'course_search_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:campusmapper/utilities/location.dart';

class TutorialPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InformationCenterPage()),
              );
            },
          ),
        ],
        title: Text('Information Center'),
        backgroundColor: Color(0xFF3498DB), // Customize header color
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Browse the list of restaurants on Campus.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Tap on a restaurant for which you want directions or menu.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'A pop-up window will appear at the bottom showing Directions and Menu options.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Click on Directions to get directions to that restaurant from your current location.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Click on Menu to view the menu of that restaurant on your screen.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.fastfood_sharp,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FoodPage()),
              );
            },
          ),
        ],
        title: Text('Campus Food'),
        backgroundColor: Color(0xFF2ECC71), // Customize header color
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Browse the list of restaurants on Campus.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Tap on a restaurant for which you want directions or menu.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'A pop-up window will appear at the bottom showing Directions and Menu options.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Click on Directions to get directions to that restaurant from your current location.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Click on Menu to view the menu of that restaurant on your screen.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.accessible,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AccessibilityDirectoryPage()),
              );
            },
          ),
        ],
        title: Text('Accessibility'),
        backgroundColor: Color(0xFFE67E22), // Customize header color
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Browse the list of restaurants on Campus.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Tap on a restaurant for which you want directions or menu.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'A pop-up window will appear at the bottom showing Directions and Menu options.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Click on Directions to get directions to that restaurant from your current location.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Click on Menu to view the menu of that restaurant on your screen.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.calendar_month,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SchedulerHandlerPage()),
              );
            },
          ),
        ],
        title: Text('My Schedule'),
        backgroundColor: Color(0xFF9B59B6), // Customize header color
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Make sure to be logged in to access your course and event data!',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Use the toggle to switch between showing your courses and events',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'When looking at events, tap to edit and hold to delete',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'When looking at events, press the + icon in the appbar to add a new event',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'When looking at events, click the calendar icon in the appbar to view your events in '
              'a calendar view',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.map,
              color: Colors.black,
            ),
            onPressed: () {
              final locationService =
                  Provider.of<LocationService>(context, listen: false);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ListMapScreen(
                        findLocation: const LatLng(0.0, 0.0), type: "None")),
              );
            },
          ),
        ],
        title: Text('Campus Map'),
        backgroundColor: Color(0xFF008080), // Customize header color
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Browse the list of restaurants on Campus.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Tap on a restaurant for which you want directions or menu.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'A pop-up window will appear at the bottom showing Directions and Menu options.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Click on Directions to get directions to that restaurant from your current location.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Click on Menu to view the menu of that restaurant on your screen.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CourseSearchPage()),
              );
            },
          ),
        ],
        title: Text('Search Courses'),
        backgroundColor: Color(0xFFFFD700), // Customize header color
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Browse the list of restaurants on Campus.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Tap on a restaurant for which you want directions or menu.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'A pop-up window will appear at the bottom showing Directions and Menu options.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Click on Directions to get directions to that restaurant from your current location.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text(
              'Click on Menu to view the menu of that restaurant on your screen.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

// Implement TutorialPage2 and TutorialPage3 similarly

class TutorialSlider extends StatefulWidget {
  @override
  _TutorialSliderState createState() => _TutorialSliderState();
}

class _TutorialSliderState extends State<TutorialSlider> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorial'),
        backgroundColor: Color(0xFFE0F2F1), // Customize header color
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                TutorialPage1(),
                TutorialPage2(),
                TutorialPage3(),
                TutorialPage4(),
                TutorialPage5(),
                TutorialPage6(),
                // Add more tutorial pages as needed
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              6, // Total number of pages
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
