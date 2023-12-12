/*
Author: Darshilkumar Patel - 100832600
This page manages the HelpButton shown on home page and when clicked on it there are detailed
guidelines for how to access each app functionality for user's assistance.
*/

import 'package:flutter/material.dart';
import 'package:campusmapper/widgets/restaurant_details.dart';
import 'accessibility.dart';
import 'scheduler_handler.dart';
import 'course_search_page.dart';

class TutorialPage1 extends StatelessWidget {
  const TutorialPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Information Center'),
        backgroundColor: Colors.black, // Customize header color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text(
              'Browse the latest campus news and updates.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.contact_phone),
            title: Text(
              'Find contact information for emergency services and make direct phone calls.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text(
              'To get more info on the campus news (perhaps messages or notifications not rendering), assistance is provided on the campus library 24/7.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage2 extends StatelessWidget {
  const TutorialPage2({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
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
        title: const Text('Campus Food'),
        backgroundColor: const Color(0xFF2ECC71), // Customize header color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.restaurant_menu),
            title: Text(
              'Browse the list of restaurants on Campus.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.touch_app),
            title: Text(
              'Tap on a restaurant for which you want directions or menu.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message_outlined),
            title: Text(
              'A pop-up window will appear at the bottom showing Directions and Menu options.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.directions),
            title: Text(
              'Click on Directions to get directions to that restaurant from your current location.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
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
  const TutorialPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
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
        title: const Text('Accessibility'),
        backgroundColor: const Color(0xFFE67E22), // Customize header color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.accessible_forward),
            title: Text(
              'Select buildings to view detailed accessibility information and find accessible entrances.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.visibility),
            title: Text(
              'Use the "Find Accessible Entrance" feature to get visual guidance to the entrance.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(
              'This will bring you to the Campus Map, showing you the way to your destination.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage4 extends StatelessWidget {
  const TutorialPage4({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SchedulerHandlerPage()),
              );
            },
          ),
        ],
        title: const Text('My Schedule'),
        backgroundColor: const Color(0xFF9B59B6), // Customize header color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text(
              'Make sure to be logged in to access your course and event data!',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.swap_horiz),
            title: Text(
              'Use the toggle to switch between showing your courses and events',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text(
              'When looking at events, press the + icon in the appbar to add a new event',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.touch_app),
            title: Text(
              'You can edit events by tapping it, and remove it with a long press',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              'When looking at events, click the calendar icon in the appbar to view your events in a calendar view',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage5 extends StatelessWidget {
  const TutorialPage5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Campus Map'),
        backgroundColor: const Color(0xFF008080), // Customize header color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.my_location),
            title: Text(
              'Allow the app to access your location to show your position on the campus map.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(
              'Explore the map to view different campus locations. Zoom in and out for a detailed or broad view.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.layers_clear),
            title: Text(
              'Tap on "Add Icons to Map" to display or hide facilities like washrooms, elevators, and food spots.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.filter_alt),
            title: Text(
              'Use the filters to select which facilities you want to see on the map. Tap "Apply Changes" to update.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.directions_walk),
            title: Text(
              'Select any location to get walking directions from your current position.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage6 extends StatelessWidget {
  const TutorialPage6({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CourseSearchPage()),
              );
            },
          ),
        ],
        title: const Text('Search Courses'),
        backgroundColor: const Color(0xFFFFD700), // Customize header color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(
            title: Text(
              'Instructions:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text(
              'Use the search bar to find courses by name, number, or instructor.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text(
              'To add a course to your schedule, tap the plus icon next to the course name.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(
              'For more details about a course, select the course from the list.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.filter_list),
            title: Text(
              'Apply filters to narrow down the search results according to your preferences.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            leading: Icon(Icons.star_border),
            title: Text(
              'Favorite courses for quick access later by tapping the star icon.',
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
  const TutorialSlider({super.key});

  @override
  TutorialSliderState createState() => TutorialSliderState();
}

class TutorialSliderState extends State<TutorialSlider> {
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
        title: const Text('Tutorial'),
        backgroundColor: const Color(0xFFE0F2F1), // Customize header color
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
              children: const [
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
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
