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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // Wrap your app with MultiProvider to provide multiple providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ScheduleProvider()), // Add this line
        // Add other providers if needed
      ],
      child: MaterialApp(
        title: 'Grade Viewer',
        home: CampusNavigatorApp(),
      ),
    ),
  );
}

class CampusNavigatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Navigator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home': (context) =>
            HomePage(), // Assign route name '/' to the HomePage
        '/events': (context) =>
            const EventsScheduler(title: 'Events Scheduler'),
        // Other named routes if needed
      },
      initialRoute: '/', // Set the initial route
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;

  void navigateToSection(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void loginUser() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void logoutUser() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> navigationCards = [
      NavigationCard(
        icon: Icons.info,
        title: 'Information Center',
        color: Color(0xFF3498DB),
        onTap: () {
          navigateToSection(context, InformationCenterPage());
        },
      ),
      NavigationCard(
        icon: Icons.fastfood_sharp,
        title: 'CampusFood',
        color: Color(0xFF2ECC71),
        onTap: () {
          navigateToSection(context, FoodPage());
        },
      ),
      NavigationCard(
        icon: Icons.accessible,
        title: 'Accessibility',
        color: Color(0xFFE67E22),
        onTap: () {
          navigateToSection(context, AccessibilityDirectoryPage());
        },
      ),
      NavigationCard(
        icon: Icons.calendar_month,
        title: 'My Schedule',
        color: Color(0xFF9B59B6),
        onTap: () {
          navigateToSection(context, SchedulerHandlerPage());
        },
      ),
      NavigationCard(
        icon: Icons.calendar_today,
        title: 'Weekly Schedule',
        color: Color(0xFF9B59B6),
        onTap: () {
          navigateToSection(context, SchedulePage());
        },
      ),
      NavigationCard(
        icon: Icons.map,
        title: 'Campus Map',
        color: Color(0xFF008080),
        onTap: () {
          navigateToSection(
              context,
              ListMapScreen(
                findLocation: const LatLng(0.0, 0.0),
              ));
        },
      ),
      NavigationCard(
        icon: Icons.search,
        title: 'Search Courses',
        color: Color(0xFFFFD700),
        onTap: () {
          navigateToSection(context, CourseSearchPage());
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

    if (!isLoggedIn) {
      navigationCards.insert(
        1,
        NavigationCard(
          icon: Icons.school,
          title: 'Student Login',
          color: Colors.white38,
          onTap: () {
            navigateToSection(context, StudentLoginPage());
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Navigator'),
        actions: isLoggedIn
            ? [
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: logoutUser,
                ),
              ]
            : [],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding: EdgeInsets.all(8.0),
        childAspectRatio: 0.8 / 1.0,
        children: navigationCards,
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({Key? key, required this.child}) : super(key: key);

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  Color _color = Colors.white;

  @override
  void initState() {
    super.initState();
    _animateBackgroundColor();
  }

  void _animateBackgroundColor() {
    Future.delayed(Duration(seconds: 1)).then((_) {
      if (mounted) {
        setState(() {
          _color = Color((0xFF000000 | math.Random().nextInt(0xFFFFFF)));
        });
        _animateBackgroundColor();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      color: _color,
      child: widget.child,
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = [
      {'name': 'Tech Workshop', 'date': 'Nov 10', 'location': 'Auditorium'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          var event = events[index];
          return ListTile(
            title: Text(event['name'] ?? 'Unknown Event'),
            subtitle: Text(
                '${event['date'] ?? 'Date not set'} at ${event['location'] ?? 'Location not set'}'),
            onTap: () {
              // Your onTap code
            },
          );
        },
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
