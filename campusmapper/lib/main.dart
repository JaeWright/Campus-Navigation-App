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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:campusmapper/screens/student_login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:campusmapper/models/firestore/firebase_options.dart';
import 'package:latlong2/latlong.dart';
import 'package:campusmapper/screens/help_button.dart';
import 'package:campusmapper/screens/course_search_page.dart';
import 'package:campusmapper/utilities/schedule_provider.dart';
import 'package:campusmapper/screens/information_centre_page.dart';
import 'package:campusmapper/screens/accessibility.dart';
import 'package:campusmapper/screens/scheduler_handler.dart';
import 'package:provider/provider.dart';
import 'package:campusmapper/screens//map_screen.dart';
import 'package:campusmapper/utilities/classes/location.dart';
import 'package:campusmapper/widgets/restaurant_details.dart';
import 'package:campusmapper/widgets/drop_menu.dart';

import 'screens/FAQ.dart';

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
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grade Viewer',
        home: CampusNavigatorApp(),
      ),
    ),
  );
}

class CampusNavigatorApp extends StatelessWidget {
  const CampusNavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Navigator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home': (context) =>
            const HomePage(), // Assign route name '/' to the HomePage
        '/scheduler': (context) => const SchedulerHandlerPage(),
        '/login': (context) => const StudentLoginPage(
              forced: false,
            ),
        // Other named routes if needed
      },
      initialRoute: '/', // Set the initial route
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
        color: const Color(0xFF3498DB),
        onTap: () {
          navigateToSection(context, const InformationCenterPage());
        },
      ),
      NavigationCard(
        icon: Icons.calendar_month,
        title: 'My Schedule',
        color: const Color(0xFF9B59B6),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/scheduler');
        },
      ),
      NavigationCard(
        icon: Icons.search,
        title: 'Search Courses',
        color: const Color(0xFFFFD700),
        onTap: () {
          navigateToSection(context, const CourseSearchPage());
        },
      ),
      NavigationCard(
        icon: Icons.map,
        title: 'Campus Map',
        color: Colors.cyan,
        onTap: () {
          navigateToSection(
            context,
            const ListMapScreen(
              findLocation: LatLng(0.0, 0.0),
              type: "None",
            ),
          );
        },
      ),
      NavigationCard(
        icon: Icons.accessible,
        title: 'Accessibility',
        color: Colors.redAccent,
        onTap: () {
          navigateToSection(context, AccessibilityDirectoryPage());
        },
      ),
      NavigationCard(
        icon: Icons.fastfood_sharp,
        title: 'Campus Food',
        color: const Color(0xFF2ECC71),
        onTap: () {
          navigateToSection(context, FoodPage());
        },
      ),
      NavigationCard(
        icon: Icons.question_answer,
        title: 'FAQ',
        color: const Color(0xFFE67E22),
        onTap: () {
          navigateToSection(context, const FAQPage());
        },
      ),
    ];
    return Scaffold(
      appBar: AppBar(
          title: const Text('Campus Navigator'),
          actions: const <Widget>[Dropdown()]),
      body: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: navigationCards.length,
        itemBuilder: (BuildContext context, int index) =>
            navigationCards[index],
        staggeredTileBuilder: (int index) {
          // Assuming 'My Schedule' is at index 3 and 'Campus Map' is at index 4
          if (index == 1 || index == 3) {
            return const StaggeredTile.count(
                2, 2); // Span 2 cells horizontally and 2 cells vertically
          } else if (index == 6) {
            return const StaggeredTile.count(
                4, 1); // Span 2 cells horizontally and 2 cells vertically
          }
          return const StaggeredTile.count(2,
              1); // Span 2 cells horizontally and 1 vertically for other cards
        },
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 8.0,
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TutorialSlider(),
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
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 32.0, color: Colors.white), // Icon color changed
              const SizedBox(height: 16.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white, // Text color changed
                  fontWeight: FontWeight.bold, // Bold text
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
