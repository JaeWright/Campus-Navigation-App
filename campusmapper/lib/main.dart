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
import 'package:campusmapper/screens/student_login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:campusmapper/models/firestore/firebase_options.dart';
import 'package:latlong2/latlong.dart';
import 'package:campusmapper/screens/helpbutton.dart';
import 'package:campusmapper/screens/course_search_page.dart';
import 'package:campusmapper/screens/schedule_page.dart';
import 'package:campusmapper/utilities/schedule_provider.dart';
import 'package:campusmapper/screens/information_centre_page.dart';
import 'package:campusmapper/screens/accessibility.dart';
import 'package:campusmapper/screens/scheduler_handler.dart';
import 'package:provider/provider.dart';
import 'package:campusmapper/screens//map_screen.dart';
import 'package:campusmapper/utilities/location.dart';
import 'package:campusmapper/screens/restaurant_details.dart';
import 'package:campusmapper/widgets/drop_menu.dart';

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
          create: (context) => ScheduleProvider(),
        ), // Add this line
        // Add other providers if needed
        Provider(
          create: (context) => LocationService(),
        ),
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
        '/scheduler': (context) => const SchedulerHandlerPage(),
        '/login': (context) => const StudentLoginPage(
              forced: false,
            ),
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
          Navigator.pushReplacementNamed(context, '/scheduler');
        },
      ),
      NavigationCard(
        icon: Icons.map,
        title: 'Campus Map',
        color: Color(0xFF008080),
        onTap: () {
          final locationService =
              Provider.of<LocationService>(context, listen: false);
          navigateToSection(
            context,
            ListMapScreen(
              findLocation: const LatLng(0.0, 0.0),
              type: "None",
            ),
          );
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
    ];
    return Scaffold(
      appBar: AppBar(
          title: Text('Campus Navigator'), actions: const <Widget>[Dropdown()]),
      body: GridView.count(
        crossAxisCount: 3,
        padding: EdgeInsets.all(8.0),
        childAspectRatio: 0.8 / 1.0,
        children: navigationCards,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TutorialSlider(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 8.0,
        tooltip: 'Help',
        child: const Icon(Icons.help),
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
      elevation: 5, // Added elevation for depth effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15), // Match border radius
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 48.0, color: Colors.white), // Icon color changed
              SizedBox(height: 16.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white, // Text color changed
                  fontWeight: FontWeight.bold, // Bold text
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
